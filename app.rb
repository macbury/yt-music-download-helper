require 'bundler'
require 'sinatra'
require 'sinatra/json'
require 'sinatra/namespace'
require 'sinatra/base'
require 'sinatra/reloader'
require 'json'
require 'taglib'
require 'pry'
require 'dotenv/load'
require 'sidekiq'

Bundler.require

require_relative './lib/ydl_helper'
require_relative './lib/metadata_processor'
require_relative './lib/download_movie_worker'

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('REDIS_URL') }
end

