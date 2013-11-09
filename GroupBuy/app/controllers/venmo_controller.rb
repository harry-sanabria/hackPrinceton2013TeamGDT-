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
      token = get_token(params[:code])
      
      result = Net::HTTP.get(URI.parse("https://api.venmo.com/me?access_token=#{token}"))
      current_user.venmo_username = ActiveSupport::JSON.decode(result)['data']['username']
      current_user.save
      
      redirect_to session.delete(:return_to), notice: "Authentication successful."
    else
      redirect_to session.delete(:return_to), notice: "Authentication failed."
    end
  end
  
  def confirm
    @code = params[:code]
  end
  
  def charge
    token = venmo_get_token_path(params[:code])

    url = URI.parse("https://api.venmo.com/payments")
    post_args = {
      'access_token' => token,
      'user_id' => '686225',
      'note' => 'Foo.',
      'amount' => '-5',
      'audience' => 'private'
    }
    resp = Net::HTTP.post_form(url, post_args)
    msg = ActiveSupport::JSON.decode(resp.body)['message']
    
    puts "THIS IS IMPORTANT!!!! ----> #{@resp.body}"
    
    redirect_to root_url, notice: msg
  end
  
end
