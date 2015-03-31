class Crawler < ActiveRecord::Base
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'json'

def self.url_check restaurant_info
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

def self.crawler_check join_table
 beginning_time = Time.now	

final_url_arr = []
	    join_table.each do |row|
		url_arr = []
		@restaurant = Restaurant.find(row.restaurant_id)
		base_url = @restaurant.url.split("?")[0]
		time_arr = []
		i = row.start_date
		x = row.start_time.hour
		covers = row.covers
		while(x<=row.end_time.hour) do
			time_arr.push(x)
			x+= 1 
		end	
		while(i<=row.end_date) do
			time_arr.each do |time|
				url_arr.push("#{base_url}?DateTime=#{i.to_s}%#{time}#{time+1}&Covers=#{covers}")	
			i+= 1
			end
		end
final_url_arr = url_arr
	end
my_hash = {};
final_url_arr.each do |rest_url|
url = rest_url
doc = Nokogiri::HTML(open(url))
y = doc.css("a.dtp-button.button").text.split(" PM")
my_hash.merge!("#{rest_url.split("=")[1].split("%")[0]}": "#{y}")
# puts "this is y:#{y}"
end
puts my_hash
# my_hash.each do |k,v|
# y = JSON.parse(v)
# # puts y.join.split
# # puts Time.parse(y.join)
# y.each do |v|
# unless v.empty? 
# puts "#{k}:#{v.delete("   ")}"
end_time = Time.now
puts "Time elapsed #{(end_time - beginning_time)*1000} milliseconds" 
# end
# end
# end	




end




end
