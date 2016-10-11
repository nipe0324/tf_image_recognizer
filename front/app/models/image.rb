class Image
  attr_accessor :data, :size, :label_no

  # @param data      [binary]  iamge data
  # @param size      [integer] imagge size (width, height)
  # @param label_no [integer] number of label
  def initialize(data, size, label_no)
    @data = Base64.decode64(data.split(',')[1])
    @size = size
    @label_no = label_no
  end

  def to_cifar10_binary
    buff = String.new
    buff << [label_no].pack('C') # convert to unsigned int 8
    image = Magick::Image.from_blob(data).first.resize(size, size)
    %w(red green blue).each do |color|
      image.each_pixel do |px|
        buff << [px.send(color) >> 8].pack('C')
      end
    end
    buff
  end
end
