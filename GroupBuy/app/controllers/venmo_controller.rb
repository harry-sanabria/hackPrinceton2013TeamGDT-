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
    ActiveSupport::JSON.decode(resp.body)
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
      current_user.venmo_code = params[:code]
      current_user.venmo_username = get_server_response(params[:code])['user']['username']
      current_user.save
      
      redirect_to session.delete(:return_to), notice: "Authentication successful."
    else
      redirect_to session.delete(:return_to), notice: "Authentication failed."
    end
  end
  
  def charge    
    purchase = Purchase.find_by_id(params[:purchase_id])
    
    url = URI.parse("https://api.venmo.com/payments")
    token = get_server_response(params[:code])['access_token']
    errors = 0
    for payment in purchase.payments
      post_args = {
        'access_token' => token,
        'user_id' => get_server_response(User.find_by_id(payment.user_id).venmo_code)['user']['id'],
        'note' => "#{current_user.venmo_username} has charged you for #{purchase.title}",
        'amount' => '%.2f' % (1.0 * payment.price / purchase.current_total_price),
        'audience' => 'private'
      }
      
      resp = Net::HTTP.post_form(url, post_args)
      if not resp.body['error'].blank?
        errors += 1
      end
    end
    if errors
      redirect_to root_url, notice: "Confirmation successful, with #{errors} errors..."
    else
      redirect_to root_url, notice: "Confirmation successful!"
    end
  end
  
end
