require 'rubygems'
require 'rspec'
require 'json'

CONFIG = JSON.parse IO.read('config.json')

RSpec.configure do |config|
  # Use color in STDOUT
  config.color_enabled = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # Use the specified formatter
  config.formatter = :documentation # :progress, :html, :textmate
end
