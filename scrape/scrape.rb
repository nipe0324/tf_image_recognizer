#!/usr/bin/env ruby
#coding: utf-8
require 'rubygems'
require 'thor'
require_relative './google_image_scraper'
require_relative './image_net_url_scraper'

# Scrape google images by using `keyword`
#
# [Usage]
# Scrape images from google
# ./scrape/scrape.rb -k keyword -n number
#
# Scrape ImageNet's image paths
# ./scrape/scrape.rb image_net
class Scrape < Thor
  default_command :google_images

  desc 'google images', 'Scrape from google image results'
  option :keyword, type: :string, aliases: '-k', desc: 'Search keyword'
  option :num_images, type: :string, aliases: '-n', desc: 'Scrape image num'
  def google_images
    keyword = options[:keyword].downcase
    num_images = options[:num_images].to_i

    # Read image urls
    puts "Search keyword: #{keyword}"
    scraper = ::GoogleImageScraper.new(keyword)
    scraper.scrape(num_images: num_images)

    # create out dir
    outdir = "data/raw/google/#{keyword}"
    Dir.mkdir(outdir) unless Dir.exists?(outdir)

    # Download images from urls
    puts "Download images to #{outdir}"
    scraper.save_images(outdir)
  end

  desc 'ImageNet images', "Scrape from ImageNet's image paths"
  def image_net
    Dir["data/image_net_urls/*"].each do |path|
      # Read image urls
      file = File.open(path)
      scraper = ImageNetUrlScraper.new(file)
      scraper.scrape

      # create out dir
      outdir = "data/raw/imagenet/#{File.basename(path)}"
      Dir.mkdir(outdir) unless Dir.exists?(outdir)

      # Download images from urls
      puts "Download images to #{outdir}"
      scraper.save_images(outdir)
    end
  end
end

Scrape.start
