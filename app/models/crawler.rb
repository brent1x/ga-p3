class Crawler < ActiveRecord::Base
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'json'

def self.url_check restaurant_info
	binding.pry
	restaurant_info.each do |restaurant|
		restaurant[:restaurant_urls].each do |el_url|
		begin
			url = el_url
			doc = Nokogiri::HTML(open(url))
			rescue OpenURI::HTTPError => e
	  		if e.message == '404 Not Found'
	  			puts "not found"
			end
		else	
			 	@restaurant = Restaurant.new(name: restaurant[:restaurant_name], city:restaurant[:restaurant_city], state: restaurant[:restaurant_state], url: el_url)
				if  @restaurant.save 
					puts "saved successfully"
				else
					puts "not found"
			
				end
		end
		
		end
end
end
end
