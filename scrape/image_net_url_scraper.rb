require 'uri'
require 'open-uri'
require 'open_uri_redirections'
require 'timeout'

class ImageNetUrlScraper
  attr_reader :file, :image_urls

  def initialize(file)
    @file = file
  end

  def scrape
    @image_urls = file.read.split("\n")
  end

  def save_images(dir)
    image_urls.each_with_index do |url, idx|
      puts "#{idx}:#{url}"
      begin
        timeout(3) do
          open(url, allow_redirections: :safe) do |image_data|
            extention = 'jpeg' # FIXME: detect image type (jpeg, png, gif, etc..)
             File.open("#{dir}/#{idx}.#{extention}", 'wb') do |file|
               file.puts image_data.read
             end
          end
        end
      rescue => ex # Redirect loop or 404 Not Found
        puts ex
      end
    end
  end
end
