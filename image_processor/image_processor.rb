require 'pry-byebug'

class ImageProcessor
  attr_accessor :src_dir, :out_dir, :image_size, :images

  IMAGE_BIN_FILE_NAMES = %w(train.bin cv.bin test.bin)
  LABELS_FILE_NAME = 'labels.json'


  def initialize(src_dir, out_dir, image_size = 32)
    @src_dir = src_dir
    @out_dir = out_dir
    @image_size = image_size
    @images = {}
  end

  def read_images
    puts "Read images: #{src_dir}"
    labels_with_index.each do |label_no, label_name|
      @images[label_name] = []
      paths = [src_dir, label_name, "*.jpeg"].join('/') # FIXME: only read jpeg file
      Dir[paths].each do |path|
        data = File.open(path).read
        @images[label_name] << Image.new(data, image_size, label_no)
      end
    end
  end

  def write_images_with_train_cv_test
    datasets = split_images
    images_and_outpath = [datasets, IMAGE_BIN_FILE_NAMES].transpose
    images_and_outpath.each do |imgs, out_path|
      write_images_by_cifar10bin(imgs, out_path)
    end
  end

  def write_labels_as_json
    out_path = [out_dir, LABELS_FILE_NAME].join('/')
    File.open(out_path, "w") { |out| out.write(labels_with_index.to_json) }
    puts "Write labels: #{out_path}"
  end

  def shuffle_images
    images.each { |_, images| images.shuffle! }
  end

  private

  def labels
    @labels ||= Dir.entries(src_dir).reject { |filename| filename.start_with?('.') }
  end

  def labels_with_index
    @labels_with_index ||= Hash[labels.map.with_index { |label, i| [i, label] }]
  end

  def split_images
    train_imgs = []
    cv_imgs    = []
    test_imgs  = []

    images.each do |label_name, imgs|
      # train:60%, cv:20%, test:20% (250 => 150/50/50)
      split_index1 = imgs.size / 10 * 6
      split_index2 = imgs.size / 10 * 8

      train_imgs.concat(imgs.select.with_index {|_, i| 0 <= i && i < split_index1})
      cv_imgs.concat(imgs.select.with_index {|_, i| split_index1 <= i && i < split_index2})
      test_imgs.concat(imgs.select.with_index {|_, i| split_index2 <= i && i < imgs.size})
    end
    [train_imgs.shuffle!, cv_imgs.shuffle!, test_imgs.shuffle!]
  end

  def write_images_by_cifar10bin(imgs, filename)
    errors = 0
    out_path = [out_dir, filename].join('/')
    data = String.new
    imgs.each do |img|
      begin
        data << img.to_cifar10_binary
      rescue
        errors += 1
      end
    end
    File.open(out_path, "wb") { |out| out.write(data) }
    puts "Write cifar10 binary: #{out_path}, num: #{imgs.size}, errors: #{errors}"
  end
end
