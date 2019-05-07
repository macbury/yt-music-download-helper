class DownloadList
  include Enumerable
  attr_reader :ids, :name

  def initialize(name, ids)
    @ids = ids
    @name = name
  end

  def each
    @ids.each { |id| yield id }
  end
end