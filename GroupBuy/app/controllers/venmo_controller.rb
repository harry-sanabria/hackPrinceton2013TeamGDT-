class VenmoController < ApplicationController
  before_action :login_required
  
  require 'net/http'
  
  private
  def get_token(code)
    url = URI.parse("https://api.venmo.com/oauth/access_token")
    post_args = {
      'client_id' => ::VENMO_CLIENT_ID,
      'code' => code,
      'client_secret' => ::VENMO_CLIENT_SECRET
    }
    resp = Net::HTTP.post_form(url, post_args)
    
    puts ::VENMO_CLIENT_ID
    puts code
    puts ::VENMO_CLIENT_SECRET
    
    ActiveSupport::JSON.decode(resp.body)['access_token']
  end
  
  def get_username(code)
    token = get_token(code)
    result = Net::HTTP.get(URI.parse("https://api.venmo.com/me?access_token=#{token}"))
    ActiveSupport::JSON.decode(result)['data']['username']
  end
  
  def get_userid(code)
    token = get_token(code)
    result = Net::HTTP.get(URI.parse("https://api.venmo.com/me?access_token=#{token}"))
    ActiveSupport::JSON.decode(result)['data']['id']
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
      current_user.venmo_username = get_username(params[:code])
      current_user.save
      
      redirect_to session.delete(:return_to), notice: "Authentication successful."
    else
      redirect_to session.delete(:return_to), notice: "Authentication failed."
    end
  end
  
  def charge    
    purchase = Purchase.find_by_id(params[:purchase_id])
    
    url = URI.parse("https://api.venmo.com/payments")
    token = get_token(current_user.venmo_code)
    errors = 0
    for user_id, price in purchase.payments
      post_args = {
        'access_token' => token,
        'user_id' => get_userid(User.find_by_id(user_id).venmo_code),
        'note' => "#{current_user.venmo_username} has charged you for #{purchase.title}",
        'amount' => '%.2f' % (1.0 * price / purchase.current_total_price),
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
