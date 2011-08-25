require 'rubygems'
require 'bundler'
Bundler.setup(:default)

require 'http_router'
require 'cramp'
require 'active_record'

require 'active_support/all'
require 'active_support/json'

require './config/routes'
require './app/helpers/application'
require './app/controllers/application_controller'
require './app/controllers/chat_controller'
require './app/controllers/retrieve_controller'
require './app/controllers/receive_controller'
require './app/controllers/static_controller'
require './app/models/chat'

db_config = YAML.load(File.read('./config/database.yml')).with_indifferent_access
ActiveRecord::Base.configurations = db_config
ActiveRecord::Base.establish_connection(ENV['RACK_ENV'] || 'development')

Cramp::Websocket.backend = :thin

# bundle exec thin --timeout 0 -V -R config.ru start
run app_routes
