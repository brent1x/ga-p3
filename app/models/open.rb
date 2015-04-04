class Open < ActiveRecord::Base
include ActionView::Helpers

def self.find_restaurant name, city, state, id
api = OpenTablesHelper::Client.new
tomorrow = Date.tomorrow.to_s
resp = api.restaurants(:name =>name, :city => city, :state => state, per_page:"5" )
return false if resp["total_entries"] == 0
	puts resp["restaurants"][0]["name"]
	puts resp["restaurants"][0]["city"]
	puts resp["restaurants"][0]["area"]
  puts resp["restaurants"][0]["id"]
@restaurant_info = []
resp["restaurants"].each do |restaurant|
  binding.pry
	@restaurant_info.push({
		restaurant_name: restaurant["name"],
		restaurant_city: restaurant["city"],
		restaurant_state: restaurant["state"],
    open_table_id: restaurant["id"],
		restaurant_urls: ["http://www.opentable.com/#{(resp["restaurants"][0]["name"].split - resp["restaurants"][0]["city"].split).join(" ").downcase.parameterize }-#{resp["restaurants"][0]["city"].downcase.parameterize}?DateTime=#{tomorrow}%2122&Covers=2",
	"http://www.opentable.com/#{(resp["restaurants"][0]["name"].split - resp["restaurants"][0]["city"].split).join(" ").downcase.parameterize }?DateTime=#{tomorrow}%2122&Covers=2"]
})
end
@restaurant_info
end

# # Process response
# resp['count']       # => records found
# resp['restaurants'] # => restaurant records

# # Fetch a single record
# api.restaurant(81169)
end
#url = "http://www.opentable.com/bourbon-steak-san-francisco?DateTime=2015-04-06%2122&Covers=2"