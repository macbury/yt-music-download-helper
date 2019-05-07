class DownloadMusicJob
  def initialize(yt_id, download_list)
    @yt_id = yt_id
    @download_list = download_list
  end

  def call
    processor.process(result) if result
  end

  private

  def result
    @result ||= helper.download(@yt_id)
  end

  def processor
    @processor ||= MetadataProcessor.new(storage_path: ENV.fetch('COMPLETED_PATH'), album: @download_list.name)
  end

  def helper
    @helper ||= YdlHelper.new(download_dir: ENV.fetch('INCOMPLETE_PATH'))
  end
end