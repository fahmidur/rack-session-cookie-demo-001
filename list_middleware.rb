#!/usr/bin/env ruby

require 'rack'

app = Rack::Builder.parse_file('config.ru').first

def rec(app, arr=[])
  arr.push(app.class.to_s)
  return arr unless app
  if app.instance_variable_defined?(:@stack)
    return rec(app.instance_variable_get(:@stack), arr)
  end
  if app.respond_to?(:app)
    return rec(app.app, arr)
  end
  rec(app.instance_variable_get(:@app), arr)
end

puts rec(app)
