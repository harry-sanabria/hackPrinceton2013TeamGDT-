class VenmoController < ApplicationController
  require 'openssl'
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
  
  def index
    
  end
  
  def confirm
    @code = params[:code]
  end
  
  def charge
    require 'net/http'
    
    @url = URI.parse("https://api.venmo.com/oauth/access_token")
    @post_args = {
      'client_id' => 1476,
      'code' => params[:code],
      'client_secret' => 'rVxpfXw9ZjvHeKzD4a3mRugfDfQP9x57'
    }
    @resp = Net::HTTP.post_form(@url, @post_args)
    @token = ActiveSupport::JSON.decode(@resp.body)['access_token']

    @url = URI.parse("https://api.venmo.com/payments")
    @post_args = {
      'access_token' => @token,
      'user_id' => '686225',
      'note' => 'Foo.',
      'amount' => '-5',
      'audience' => 'private'
    }
    @resp = Net::HTTP.post_form(@url, @post_args)
    @msg = ActiveSupport::JSON.decode(@resp.body)['message']
    
    puts "THIS IS IMPORTANT!!!! ----> #{@resp.body}"
    
    redirect_to root_url, notice: @msg
  end
  
end
