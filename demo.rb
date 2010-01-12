require 'rubygems'
require 'sinatra'
require 'thin'

class MyApp < Sinatra::Base
  enable :static
end

Thin::Logging.trace = true
Rack::Handler::Thin.run MyApp, :Port => 3001