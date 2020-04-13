class FindPlaylistWorker
  include Sidekiq::Worker

  def perform(url)
    helper.get_playlist_videos_ids(url).each do |youtube_id|
      DownloadMovieWorker.perform_async(youtube_id)
    end
  end

  private

  attr_reader :url

  def helper
    @helper ||= YdlHelper.new(download_dir: ENV.fetch('INCOMPLETE_PATH'))
  end
end