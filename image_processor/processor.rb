#!/usr/bin/env ruby
#coding: utf-8
require 'rubygems'
require 'thor'
require 'json'
require_relative './image'
require_relative './image_processor'

# Process your images to CIFAR-10 binary
#
# [Usage] ./image_processor/processor.rb -s ./data/raw/google -o ./data/input -i 32
#
class Processor < Thor
  default_command :execute

  desc 'Processor', 'Process your images to CIFAR-10 binary'
  option :src_dir,  type: :string,  aliases: '-s', desc: 'Src dir'
  option :out_dir,  type: :string,  aliases: '-o', desc: 'Out dir'
  option :image_size, type: :string,  aliases: '-i', desc: 'Image size (width = height)'
  def execute
    src_dir = options['src_dir']
    out_dir = options['out_dir']
    image_size = options.fetch('image_size', 32).to_i

    puts "Start Image Processor"
    processor = ImageProcessor.new(src_dir, out_dir, image_size)
    processor.read_images
    processor.shuffle_images
    processor.write_images_with_train_cv_test
    processor.write_labels_as_json
    puts "Complete to process images!!"
  end
end

Processor.start
