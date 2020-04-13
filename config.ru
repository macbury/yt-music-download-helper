require_relative './routes'
require 'sidekiq/web'

run Rack::URLMap.new(
  '/' => Routes, 
  '/api/sidekiq' => Sidekiq::Web
)