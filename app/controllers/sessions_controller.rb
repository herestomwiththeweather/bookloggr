require 'uri'
require 'cgi'
require 'net/https'

class SessionsController < ApplicationController
  before_action :setup_oauth_params # for create
  skip_before_action :verify_authenticity_token

  def new
  end

  def create
    Rails.logger.info "me url: #{params[:me]}"
    session[:me] = URI(params[:me]).normalize.to_s
    discovery_response = IndieWeb::Endpoints.get(params[:me])
    session[:auth_endpoint] = discovery_response[:authorization_endpoint]
    session[:token_endpoint] = discovery_response[:token_endpoint]
    session[:micropub_endpoint] = discovery_response[:micropub]
    session[:oauth_state] = SecureRandom.hex
    u = URI.parse(auth_endpoint)
    uri = URI::HTTPS.build(:host => u.host, :path => u.path, :query => {scope: scope, response_type: 'code', state: session[:oauth_state], me: params[:me], client_id: @client_id, redirect_uri: @redirect_uri}.to_query)
    redirect_to uri.to_s, allow_other_host: true
  rescue => e
    Rails.logger.info "Error: #{e.class.name} : #{e.message} : url: #{params[:me]}"
    redirect_to login_url, notice: "Bad url"
  end

  def destroy
    session[:user_id] = nil
    session[:auth_endpoint] = nil
    session[:token_endpoint] = nil
    session[:micropub_endpoint] = nil
    session[:access_token] = nil
    session[:oauth_state] = nil
    redirect_to login_url, notice: "Logged out"
  end

  def callback
    if params[:code]
      if params[:state] == session[:oauth_state]
        session[:oauth_state] = nil
        me = get_authenticated_user(params[:code])
        if me.present?
          user = User.find_or_create_by(url: me)
          session[:user_id] = user.id
          session[:oauth_state] = nil
          redirect_to books_url
        else
          redirect_to login_url, "Authentication failure"
        end
      else
        Rails.logger.info "Error. state #{params[:state]} does not match stored state #{session[:oauth_state]}"
        session[:oauth_state] = nil
      end
    else
      redirect_to login_url, notice: "Auth endpoint did not return a code"
    end

    respond_to do |format|
      format.html
    end
  end

  private

  def scope
    'create update delete undelete'
  end

  def auth_endpoint
    session[:auth_endpoint]
  end

  def token_endpoint
    session[:token_endpoint]
  end

  def micropub_endpoint
    session[:micropub]
  end

  def get_authenticated_user(code)
    me = nil
    u = URI.parse(token_endpoint)
    http = ::Net::HTTP.new(u.host, u.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    body = "code=#{CGI::escape code}&client_id=#{CGI::escape @client_id}&redirect_uri=#{CGI::escape @redirect_uri}"
    response = http.post(u.path, body, "Content-Type" => "application/x-www-form-urlencoded\r\n", "Accept" => "application/json\r\n")
    parsed_response = JSON.parse(response.body)
    if parsed_response['error'].present?
      Rails.logger.info "Error: parsed response: #{parsed_response['error'].to_s}"
    else
      me = URI(parsed_response['me']).normalize.to_s
      if me != session[:me]
        Rails.logger.info "get_authenticated_user error. #{me} does not match #{session[:me]}"
        me = nil
      else
        session[:access_token] = parsed_response['access_token']
        Rails.logger.info "get_authenticated_user success: #{me}"
      end
    end
    me
  end

  def setup_oauth_params
    @client_id = ENV['CLIENT_ID']
    @redirect_uri = "#{@client_id}callback"
  end
end
