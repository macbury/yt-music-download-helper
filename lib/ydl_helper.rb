require 'pycall'
require 'pycall/import'
class YdlHelper
  attr_reader :download_dir

  def initialize(download_dir: '/tmp/')
    @download_dir = Pathname.new(File.expand_path(download_dir))
    FileUtils.mkdir_p(download_dir)
  end

  def get_download_list(url)
    playlist_data = ydl_with(extract_info_params).extract_info(url, false, false)
    return false unless playlist_data

    extractor = playlist_data['extractor'].downcase
    if extractor == 'youtube:playlist'
      DownloadList.new(playlist_data['title'], playlist_data['entries'].map { |e| e && e['id'] }.compact)
    else
      DownloadList.new(playlist_data['title'], [playlist_data['id']])
    end
  end

  def download(url)
    result = ydl_with(download_params).extract_info(url, true, false)
    
    return false unless result

    result.to_h.merge({
      'output' => {
        'audio' => download_dir.join(result['id']+ '.mp3'),
        'preview' => download_dir.join(result['id']+ '.jpg')
      }
    })
  end

  private

  def ydl_with(params)
    PyCall.import_module('youtube_dl').YoutubeDL.new(params: params)
  end

  def download_params
    {
      'format': 'bestaudio/best',
      'writethumbnail': true,
      'nocheckcertificate': true,
      'outtmpl': download_dir.join('%(id)s.%(ext)s').to_s,
      'ignoreerrors': true,  # Do not stop on download errors.
      'nooverwrites': true,  # Prevent overwriting files.
      'forceurl': true,  # Force printing final URL.
      'forcethumbnail': true,  # Force printing thumbnail URL.
      'forcefilename': true,  # Force printing final filename.
      'listformats': false, # Print an overview of available video formats and exit.,
      'postprocessors': [
        { key: 'FFmpegMetadata' },
        {
          'key': 'FFmpegExtractAudio',
          'preferredcodec': 'mp3',
          'preferredquality': '198',
        }
      ]
    }
  end

  def extract_info_params
    {
      ignoreerrors: true,
      nooverwrites: true,
      format: 'bestaudio/best',
      listformats: false,
      forcefilename: true,
      forcethumbnail: true,
      'nocheckcertificate': true,
      forceurl: true,
      postprocessors: [
        { key: 'FFmpegMetadata' },
        {
          'key': 'FFmpegExtractAudio',
          'preferredcodec': 'mp3',
          'preferredquality': '198',
        }
      ]
    }
  end
end