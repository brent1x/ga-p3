class Crawler < ActiveRecord::Base
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'json'

def self.url_check restaurant_info
	binding.pry

dates = ["2015-03-30"]
	restaurant_info[:restaurant_urls].each do |el_url|
# my_hash = {};
	begin
		url = el_url
		binding.pry
		doc = Nokogiri::HTML(open(url))
		rescue OpenURI::HTTPError => e
  		if e.message == '404 Not Found'
  			binding.pry
  			puts "not found"
		end
	else	
		binding.pry
		 	@restaurant = Restaurant.new(name: restaurant_info[:restaurant_name], city:restaurant_info[:restaurant_city],state: restaurant_info[:restaurant_state], url: [el_url])
			if  @restaurant.save 
				puts "saved successfully"
				return true
			else
				puts "not found"
		
			end
	end
	
	end
	return false
end
end
