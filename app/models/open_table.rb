# class Open < ActiveRecord::Base
# include OpenTable
# api = OpenTable::Client.new

# # Find restaurants
# resp = api.restaurants(:name =>"SPQR", :city => "San Francisco", :state => "CA", per_page:"5" )
# puts resp["restaurants"][0]["reserve_url"]
# puts resp

# # Process response
# resp['count']       # => records found
# resp['restaurants'] # => restaurant records

# # Fetch a single record
# api.restaurant(81169)
# end
