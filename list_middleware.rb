#!/usr/bin/env ruby


require 'rack'
def middleware_classes(app)                                                                                                                                              
  r = [app]

  while ((next_app = r.last.instance_variable_get(:@app)) != nil)
    r << next_app
  end

  r.map{|e| e.instance_variable_defined?(:@app) ? e.class : e }
end

app = Rack::Builder.parse_file('config.ru').first

p middleware_classes(app)
