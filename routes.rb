require_relative './app'

class Routes < Sinatra::Base
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
      url = param['query']
      if url
        DownloadMovieWorker.perform_async(url)
        json success: true, title: 'Done'
      else
        json success: false
      end
    end
  end

end
