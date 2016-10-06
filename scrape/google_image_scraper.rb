require 'uri'
require 'open-uri'
require 'selenium-webdriver'
require 'pry-byebug'

# Scrape from google image search results
class GoogleImageScraper
  attr_reader :keyword, :url, :image_urls

  def initialize(keyword)
    @keyword = keyword
    @url = "https://www.google.co.jp/search?q=#{URI.encode(keyword)}&source=lnms&tbm=isch"
  end

  def scrape(num_images: 200)
    driver.navigate.to url
    scroll_buttom(num_images)
    check_load_images!(num_images)
    scrape_image_data(num_images)
    driver.quit
  end

  def save_images(dir)
    image_urls.each_with_index do |url, idx|
      open(url) do |image_data|
        extention = 'jpeg' # FIXME: detect image type (jpeg, png, gif, etc..)
         File.open("#{dir}/#{idx}.#{extention}", 'wb') do |file|
           file.puts image_data.read
         end
      end
    end
  end

  private

  def driver
    @driver ||= Selenium::WebDriver.for :chrome
  end

  def images_elements
    driver.find_elements(:class_name, 'rg_ic')
  end

  # For load images
  def scroll_buttom(num_images)
    scroll_times = (num_images / 100.0).ceil # maybe load 100 image by 1 scroll
    scroll_times.times do |n|
      driver.find_element(:id, 'smb').click if driver.find_element(:id, 'smb').displayed?
      driver.execute_script "window.scrollBy(0, document.body.scrollHeight)"
      sleep 2
    end
  end

  def check_load_images!(num_images)
    if images_elements.size < num_images
      raise "Load Image Error: #{images_elements.size} < #{num_images}"
    end
  end

  def scrape_image_data(num_images)
    src_arr = images_elements.map {|e| e.attribute(:src) }
    @image_urls = src_arr.select { |src| src.to_s.start_with?('https://') }[0, num_images]
  end
end
