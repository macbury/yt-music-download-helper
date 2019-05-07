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

Bundler.require

require_relative './lib/download_list'
require_relative './lib/ydl_helper'
require_relative './lib/metadata_processor'
require_relative './lib/workers'
require_relative './lib/download_music_job'

class App < Sinatra::Base
  register Sinatra::Namespace
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    File.read(File.join('public', 'index.html'))
  end

  namespace '/api' do
    post '/add' do
      request.body.rewind
      param = JSON.parse(request.body.read)
      download_list = YdlHelper.new.get_download_list(param['query'] || '')
      if download_list
        download_list.each { |id| Workers.push(DownloadMusicJob.new(id, download_list)) }

        json success: true, title: download_list.name
      else
        json success: false
      end
    end

    get '/jobs' do
      json size: Workers.instance.size
    end
  end

end
