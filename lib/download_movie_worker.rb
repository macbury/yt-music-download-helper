class DownloadMovieWorker
  include Sidekiq::Worker

  def perform(url)
    @url = url
    processor.process(info) if info
  end

  private

  attr_reader :url

  def info
    @info ||= helper.download(url)
  end

  def processor
    @processor ||= MetadataProcessor.new(storage_path: ENV.fetch('COMPLETED_PATH'), album: info[:album])
  end

  def helper
    @helper ||= YdlHelper.new(download_dir: ENV.fetch('INCOMPLETE_PATH'))
  end
end