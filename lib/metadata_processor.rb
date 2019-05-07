class MetadataProcessor
  attr_reader :storage_path, :album

  def initialize(storage_path:, album:)
    @album = album
    @storage_path = Pathname.new(File.expand_path(storage_path)).join(album)
  end

  def process(result)
    FileUtils.mkdir_p(storage_path)
    audio_path = result.dig('output', 'audio')
    preview_path = result.dig('output', 'preview')

    track_title = result['title'].gsub('/', ' ')

    TagLib::MPEG::File.open(audio_path.to_s, true) do |mp3|
      tag = mp3.id3v2_tag
      tag.title = result['title']

      apic = TagLib::ID3v2::AttachedPictureFrame.new
      apic.mime_type = "image/jpeg"
      apic.description = "Cover"
      apic.type = TagLib::ID3v2::AttachedPictureFrame::FrontCover
      apic.picture = File.open(preview_path, 'rb') { |f| f.read }
  
      tag.add_frame(apic)

      mp3.save
    end

    FileUtils.cp(
      audio_path,
      storage_path.join("#{track_title}#{audio_path.extname}")
    )
  ensure
    File.unlink(audio_path)
    File.unlink(preview_path)
  end
end