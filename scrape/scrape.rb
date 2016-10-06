#!/usr/bin/env ruby
#coding: utf-8
require 'rubygems'
require 'thor'
require_relative './google_image_scraper'

# Scrape google images by using `keyword`
#
# [Usage] ./scrape/scrape.rb -k keyword -n number
#
class Scrape < Thor
  DATA_PATH = './data/raw'

  default_command :google_images

  desc 'google images', 'Scrape from google image results'
  option :keyword, type: :string, aliases: '-k', desc: 'Search keyword'
  option :num_images, type: :string, aliases: '-n', desc: 'Scrape image num'
  def google_images
    keyword = options[:keyword].downcase
    num_images = options[:num_images].to_i

    puts "Search keyword: #{keyword}"
    scraper = ::GoogleImageScraper.new(keyword)
    scraper.scrape(num_images: num_images)

    # create store dir
    dir = "#{DATA_PATH}/#{keyword}"
    Dir.mkdir(dir) unless Dir.exists?(dir)

    puts "Download images to #{dir}"
    scraper.save_images(dir)
  end
end

Scrape.start
