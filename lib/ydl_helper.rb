require 'terrapin'
require 'digest'

class YdlHelper
  attr_reader :download_dir

  def initialize(download_dir: '/tmp/')
    @download_dir = Pathname.new(File.expand_path(download_dir))
    
    FileUtils.mkdir_p(download_dir)
  end

  def get_playlist_videos_ids(url)
    hash = Digest::MD5.hexdigest(url)
    result_path = jsons_output_path(hash)
    FileUtils.mkdir_p(result_path)

    begin
      exec_command(get_playlist_arguments(hash), { url: url })
    rescue => e

    end

    Dir.glob(result_path + '*.json').map do |youtube_vide_path|
      File.basename(youtube_vide_path, '.info.json')
    end
  end

  def get_info(url)
    response = exec_command(info_arguments, { url: url })

    result = JSON.parse(response)

    {
      title: result['title'],
      album: result['album'],
      id: result['id']
    }
  end

  def download(url)
    exec_command(download_arguments, {
      url: url
    })

    result = get_info(url)

    result.to_h.merge({
      output: {
        audio: download_dir.join(result[:id]+ '.mp3'),
        preview: download_dir.join(result[:id]+ '.jpg')
      }
    })
  end

  private

  def exec_command(args, opts)
    line = Terrapin::CommandLine.new('youtube-dl', "#{options_to_commands(args)} :url")
    puts line.command(opts)
    line.run(opts)
  end

  def info_arguments
    {
      'dump-json': true,
      'ignore-errors': true
    }
  end

  def download_arguments
    {
      'extract-audio': true,
      'format': 'bestaudio/best'.inspect,
      'write-thumbnail': true,
      'embed-thumbnail': true,
      'no-check-certificate  ': true,
      'output': download_dir.join('%(id)s.%(ext)s').to_s.inspect,
      'ignore-errors': true,  # Do not stop on download errors.
      'no-overwrites': true,  # Prevent overwriting files
      'prefer-ffmpeg': true,
      'audio-format': 'mp3',
      'audio-quality': 0
    }
  end

  def get_playlist_arguments(id)
    {
      'write-info-json': true,
      'ignore-errors': true,
      'skip-download': true,
      'output': jsons_output_path(id).join("%(id)s.%(ext)s").to_s.inspect,
    }
  end

  def jsons_output_path(id)
    download_dir.join("#{id}/")
  end

  def options_to_commands(options)
    commands = []
    options.each do |key, value|
      if value.to_s == 'true'
        commands.push "--#{key}"
      elsif value.to_s == 'false'
        commands.push "--no-#{key}"
      else
        commands.push "--#{key} #{value}"
      end
    end
    commands.join(' ')
  end  
end