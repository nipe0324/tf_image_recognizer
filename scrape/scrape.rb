#!/usr/bin/env ruby
#coding: utf-8
require 'rubygems'
require 'thor'
require_relative './google_image_scraper'

# Scrape google images by using `keyword`
#
# [Usage] ./scrape/scrape.rb -k keyword
#
class Scrape < Thor
  DATA_PATH = './data/raw'

  default_command :google_images

  desc 'google images', 'Scrape from google image results'
  option :keyword, type: :string, aliases: '-k', desc: 'Search keyword'
  def google_images
    keyword = options[:keyword].downcase
    puts "Search keyword: #{keyword}"
    scraper = ::GoogleImageScraper.new(keyword)
    scraper.scrape

    # create store dir
    dir = "#{DATA_RELATIVE_PATH}/#{keyword}"
    Dir.mkdir(dir) unless Dir.exists?(dir)

    puts "Download images to #{dir}"
    scraper.save_images(dir)
  end
end

Scrape.start
