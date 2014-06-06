require 'rubygems'
require 'sinatra'

require './app.rb'
set :environment, :production
set :port, 80
set :root, Pathname(__FILE__).dirname
set :run, false
run Sinatra::Application