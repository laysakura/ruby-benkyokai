module Compressor

  # 共通の実装を提供
  def raw_length
    raw_data.length
  end

  def compressed_length
    compressed_data.length
  end

  def compression_type
    type
  end

  # インターフェイスを提供
  def compress!(raw_data)
  end
end


class Gzip
  include Compressor  # Compressorという「特徴」を宣言

  attr_reader :raw_data, :compressed_data, :type

  def initialize(raw_data)
    @raw_data = raw_data
    @type = :gzip
  end

  # Compressorでインターフェイスとして指定されたメソッドを定義する
  def compress!
    @compressed_data = gzip @raw_data
  end

  private

  def gzip(raw_data)
    '[gzip]' + raw_data
  end
end


class Snappy
  include Compressor

  attr_reader :raw_data, :compressed_data, :type

  def initialize(raw_data)
    @raw_data = raw_data
    @type = :snappy
  end

  def compress!
    @compressed_data = snappy @raw_data
  end

  private

  def snappy(raw_data)
    '[snappy]' + raw_data
  end
end


gzip_obj = Gzip.new 'hello world'
snappy_obj = Snappy.new 'hello world'

[gzip_obj, snappy_obj].each do |obj|
  obj.compress!
  p "compression type: #{obj.compression_type}, raw size: #{obj.raw_length}, compressed size: #{obj.compressed_length}"
end
