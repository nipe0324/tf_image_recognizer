require 'pry-byebug'

class ImageProcessor
  attr_accessor :src_dir, :out_dir, :image_size, :images

  IMAGE_BIN_FILE_NAMES = %w(train.bin cv.bin test.bin)
  LABELS_FILE_NAME = 'labels.json'


  def initialize(src_dir, out_dir, image_size = 32)
    @src_dir = src_dir
    @out_dir = out_dir
    @image_size = 32
    @images = []
  end

  def read_images
    puts "Read images: #{src_dir}"
    labels_with_index.each do |label_no, label_name|
      paths = [src_dir, label_name, "*.jpeg"].join('/') # FIXME: only read jpeg file
      Dir[paths].each do |path|
        data = File.open(path).read
        @images << Image.new(data, image_size, label_no)
      end
    end
  end

  def write_images_with_train_cv_test
    # train:80%, cv:10%, test:10%
    split_index1 = images.size / 10 / 8
    split_index2 = images.size / 10 / 9

    train_images = images[0, images.size - split_index1]
    cv_images    = images[images.size-split_index1, images.size-split_index2]
    test_images  = images[image_size-split_index2, images.size]

    datasets = [[train_images, cv_images, test_images], IMAGE_BIN_FILE_NAMES].transpose
    datasets.each do |images, filename|
      write_images_by_cifar10bin(images, filename)
    end
  end

  def write_labels_as_json
    out_path = [out_dir, LABELS_FILE_NAME].join('/')
    File.open(out_path, "w") { |out| out.write(labels_with_index.to_json) }
    puts "Write labels: #{out_path}"
  end

  def shuffle_images
    images.shuffle!
  end

  private

  def labels
    @labels ||= Dir.entries(src_dir).reject { |filename| filename.start_with?('.') }
  end

  def labels_with_index
    @labels_with_index ||= Hash[labels.map.with_index { |label, i| [i, label] }]
  end

  def write_images_by_cifar10bin(images, filename)
    out_path = [out_dir, filename].join('/')
    data = String.new
    images.each { |image| data << image.to_cifar10_binary }
    File.open(out_path, "wb") { |out| out.write(data) }
    puts "Write cifar10 binary: #{out_path}"
  end
end
