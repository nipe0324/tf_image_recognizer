#!/usr/bin/env ruby
#coding: utf-8
require 'rubygems'
require 'thor'
require_relative './image'

# Process your images to CIFAR-10 binary
#
# [Usage] ./image_processor/processor.rb -s ./data/raw -o ./data/input
#
class Processor < Thor
  IMAGE_SIZE = 32

  default_command :execute

  desc 'Processor', 'Process your images to CIFAR-10 binary'
  option :src_dir,  type: :string,  aliases: '-s', desc: 'Src dir'
  option :out_dir,  type: :string,  aliases: '-o', desc: 'Out dir'
  def execute
    src_dir = options[:src_dir]
    out_dir = options[:out_dir]
    src_path = "#{src_dir}/*"
    out_path = "#{out_dir}/images.bin"

    puts "Read Images from #{src_path}"
    labels = Hash[Dir[src_path].map.with_index { |dir, idx| [idx, dir.gsub("#{src_dir}/", "")] }]

    puts "Labels: #{labels}"

    images = []
    labels.each do |label_no, label_name|
      path = [src_dir, label_name, "*.jpeg"].join('/') # FIXME: only read jpeg
      Dir[path].each do |file_path|
        data = File.open(file_path).read
        images << Image.new(data, IMAGE_SIZE, label_no)
      end
    end

    puts "shuffle images"
    images.shuffle!

    puts "Write cifar10 image to #{out_path}"
    data = String.new
    images.each { |image| data << image.to_cifar10_binary }
    File.open(out_path, "wb") do |out|
      out.write(data)
    end

    puts "Complete to process images!!"
  end
end

Processor.start
