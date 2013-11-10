class VenmoController < ApplicationController
  before_action :login_required
  
  require 'net/http'
  
  private
  def get_server_response(code)
    url = URI.parse("https://api.venmo.com/oauth/access_token")
    post_args = {
      'client_id' => ::VENMO_CLIENT_ID,
      'code' => code,
      'client_secret' => ::VENMO_CLIENT_SECRET
    }
    resp = Net::HTTP.post_form(url, post_args)
    response = ActiveSupport::JSON.decode(resp.body)
    
    if not response['error'].blank?
      puts "ERROR: Problem exchanging access code (#{code}) with token. #{response['error']['errors']}"
    else
      return response
    end
  end
  
  def valid_token(venmo)
    if Time.now - venmo.updated_at > 30.days
      response = get_server_response(venmo.refresh_code)
      venmo.token = response['access_token']
      venmo.refresh_code = response['refresh_token']
    end
    
    return venmo.token
  end
  
  public
  def authenticate
    session[:return_to] ||= request.referer
    redirect_to "http://api.venmo.com/oauth/authorize?"\
                "client_id=#{::VENMO_CLIENT_ID}&"\
                "scope=access_profile,make_payments&"\
                "response_type=code&"\
                "redirect_uri=#{::DOMAIN}venmo/save"
  end
  
  def save
    if not params[:error]
      if !current_user.venmo.blank?
        current_user.venmo.destroy
      end
      resp = get_server_response(params[:code])
      venmo = Venmo.new(
                  username: resp['user']['username'],
                  venmo_id: resp['user']['id'],
                  token: resp['access_token'],
                  refresh_code: resp['refresh_token']
      )
      current_user.venmo = venmo
      if !current_user.save
        redirect_to session.delete(:return_to), notice: "Problem associating account. Try again."
        return
      end
      
      redirect_to session.delete(:return_to), notice: "Authentication successful."
    else
      redirect_to session.delete(:return_to), notice: "Authentication failed."
    end
  end
  
  def charge    
    purchase = Purchase.find_by_id(params[:purchase_id])
    final_price = params[:final_price].to_f

    # Prevents unauthorized access by other users
    if current_user.id != purchase.user_id
      flash[:notice] = "You don't have permission to view that page!"
      redirect_to current_user
      return
    end

    purchase.state = 4
    purchase.save
    
    url = URI.parse("https://api.venmo.com/payments")
    errors = 0
    for payment in purchase.payments
      next if payment.user_id == current_user.id        #Skip if yourself
      post_args = {
        'access_token' => valid_token(current_user.venmo),
        'user_id' => User.find_by_id(payment.user_id).venmo.venmo_id,
        'note' => "From #{current_user.venmo.username} for purchase: #{purchase.title}. Pickup info: #{params[:pickup_details]}",
        'amount' => "%.2f" % (-1.0 * payment.price * final_price / purchase.current_total_price),
        'audience' => 'private'
      }
      resp = Net::HTTP.post_form(url, post_args)
      response = ActiveSupport::JSON.decode(resp.body)
      
      if not response['error'].blank?
        puts "ERROR: Problem charging #{User.find_by_id(payment.user_id).venmo.username}. #{response['error']['message']}"
        errors += 1
      end
    end
    if errors > 0
      redirect_to purchases_path, notice: "Purchase finalized, but with #{errors} errors... Contact admin for details."
    else
      redirect_to purchases_path, notice: "Purchase finalized! Charges have been sent to those who joined."
    end
  end
  
end
