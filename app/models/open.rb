class Open < ActiveRecord::Base
include ActionView::Helpers

def self.find_restaurant name, city, state
api = OpenTablesHelper::Client.new	
tomorrow = Date.tomorrow.to_s
resp = api.restaurants(:name =>name, :city => city, :state => state, per_page:"5" )
return false if resp["total_entries"] == 0 
	puts resp["restaurants"][0]["name"]
	puts resp["restaurants"][0]["city"]
	puts resp["restaurants"][0]["area"]
@restaurant_info = {
	restaurant_name: resp["restaurants"][0]["name"],
	restaurant_city: resp["restaurants"][0]["city"],
	restaurant_area: resp["restaurants"][0]["area"],
	restaurant_urls: ["http://www.opentable.com/#{(resp["restaurants"][0]["name"].split - resp["restaurants"][0]["city"].split).join(" ").downcase.parameterize }-#{resp["restaurants"][0]["city"].downcase.parameterize}?DateTime=#{tomorrow}%2122&Covers=2",
"http://www.opentable.com/#{(resp["restaurants"][0]["name"].split - resp["restaurants"][0]["city"].split).join(" ").downcase.parameterize }?DateTime=#{tomorrow}%2122&Covers=2"]
} 
@restaurant_info
end

# # Process response
# resp['count']       # => records found
# resp['restaurants'] # => restaurant records

# # Fetch a single record
# api.restaurant(81169)
end
#url = "http://www.opentable.com/bourbon-steak-san-francisco?DateTime=2015-04-06%2122&Covers=2"