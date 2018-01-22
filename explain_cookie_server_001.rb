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
      :secret => 'secret_key'
  
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

  def aresponse(merge={})
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
    #binding.pry
    return ret.to_json
  end

  get '/' do
    return aresponse
  end

  get '/session/clear' do
    session.clear
    return aresponse(:message => "session cleared")
  end

  get '/cookies/clear' do
    cookies.clear
    return aresponse(
      :message => "cookies cleared BUT session remains intact",
    )
  end

  get '/cookies/set' do; return set_on(cookies); end
  get '/cookies/del' do; return del_on(cookies); end
  get '/session/set' do; return set_on(session); end
  get '/session/del' do; return del_on(session); end

  protected

  def set_on(thing)
    key, val = params.values_at(:key, :val)
    return aresponse(:ok => false, :message => 'Expecting params :key and :val') unless key && val
    thing[key] = val
    return aresponse(:ok => true, :message => "value added to #{thing.class.name}")
  end

  def del_on(thing)
    key = params[:key]
    return aresponse(:ok => false, :message => 'Expecting params :key') unless key
    return aresponse(:ok => false, :message => 'Nothing to delete at :key') unless thing[key]
    thing.delete(key)
    return aresponse(:ok => true, :message => "key deleted on #{thing.class.name}")
  end
end
