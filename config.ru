require './explain_cookie_server_001.rb'
require 'rack'
require 'rack/builder'

class CustomWrapper
  def initialize(app)
    @app = app
  end

  def call(env)
    response = @app.call(env)

    status = response[0]
    headers = response[1]
    body = response[2].join("\n")
    
    if headers['Content-Type'] == 'application/json' && (body_data=(JSON.parse(body) rescue nil))

      xdata = {}
      xdata['response_headers_raw'] = headers


      rh_parsed = {};

      set_cookie = headers['Set-Cookie']
      if set_cookie
        parsed_set_cookie = parseCookie(set_cookie)
        rh_parsed['Set-Cookie'] = parsed_set_cookie
        puts "--- set_cookie = \n---\n#{set_cookie}\n---\n"
        puts "--- parsed_set_cookie = \n---\n#{parsed_set_cookie}\n---\n"

        #--- Alter data
        if body_data['data'] && body_data['data']['cookies_aft']
          body_data['data']['cookies_aft'].merge!(normCookie(parsed_set_cookie))
        end
      end

      #xdata['env'] = env
      xdata['response_headers_parsed'] = rh_parsed
      #body_data['XDATA'] = xdata

      body = body_data.to_json

      response[2] = [body]
      headers['Content-Length'] = body.size.to_s
      response[1] = headers
    end

    return response
  end

  protected

  def parseCookie(str)
    return nil unless str
    return nil if str.size == 0
    cookie = {}
    str.split("\n").each do |substr|
      data = substr.strip.split('; ').inject({}) {|h, e| p=e.split('='); h[p[0]] = p[1]; h}
      cookie.merge!(data)
    end
    return cookie
  end

  def normCookie(cookie)
    ['domain', 'path', 'expires', 'HttpOnly', 'max-age'].each do |k|
      cookie.delete(k)
    end
    return cookie
  end
end


#run CookieServer.new

#---

cookieServer = CookieServer.new
cookieServerWrapper = CustomWrapper.new(cookieServer)

# Rack::Builder is not needed
#app = Rack::Builder.new do
  #run cookieServerWrapper
#end
#run app

# Equivalent to this
run cookieServerWrapper
