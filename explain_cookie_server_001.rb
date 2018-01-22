# This is a simple demo server
# for the exploration of session::cookie

require 'sinatra/base'
require 'sinatra/cookies'
require 'pry'
require 'json'

class CookieServer < Sinatra::Base
  helpers Sinatra::Cookies
  enable :sessions

  SESSION_PREFIX = 'SESSION_TEST'
  COOKIES_PREFIX = 'COOKIES_TEST'

  use Rack::Session::Cookie,
      :key => 'rack.session',
      :domain => 'localhost',
      :path => '/',
      :expire_after => (24 * 60 * 60), # seconds
      :secret => 'secret_encryption_key'
  
  # This gets run before every request.
  # We are saying that every request is going to respond
  # with JSON. That we do not need to specify it in every
  # Action block
  before do
    content_type :json
    session["#{SESSION_PREFIX}_timestamp"] = "testvalue_#{Time.now.to_i}"

    session["#{SESSION_PREFIX}_pageviews"] ||= Hash.new(0)
    session["#{SESSION_PREFIX}_pageviews"][request.path_info] += 1
  end

  before do
    @cookies_bef = cookies.to_h
    @session_bef = session.to_h
  end

  def success_response(merge={})
    ret = {
      ok: true,
      data: {
        cookies_bef: @cookies_bef, # Before we made any changes to the cookies
        cookies_cur: cookies.to_h, # After we made changes to the cookies
        cookies_aft: {},
        session_bef: @session_bef,
        session_cur: session.to_h,
      },
      params: params.to_h
    }
    ret.merge!(merge)
    return ret.to_json
  end

  get '/' do
    return success_response
  end

  get '/session/clear' do
    session.clear
    return success_response(:message => "session cleared")
  end

  get '/cookies/clear' do
    cookies.clear
    return success_response(
      :message => "cookies cleared BUT session remains intact",
    )
  end

  get '/cookies/add' do
  end

  get '/cookies/del' do
  end
end
