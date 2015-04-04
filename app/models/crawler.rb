class Crawler < ActiveRecord::Base

	require 'rubygems'
	require 'nokogiri'
	require 'open-uri'
	require 'json'
	require 'twilio-ruby'

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
					@restaurant = Restaurant.new(name: restaurant[:restaurant_name], city:restaurant[:restaurant_city], state: restaurant[:restaurant_state], open_table_id: restaurant[:open_table_id], url: el_url)
					if  @restaurant.save
						puts "saved successfully"
					else
						puts "not found"

					end
				end

			end
		end
	end
	def self.get_rest
		x = Restaurant.all
		puts x["name"]
	end

	def self.crawler_check
		join = CueRestaurant.all
		join_by_user = join.group_by{|row| row.user_id}
		puts join_by_user
		join_by_user.each do |join_table|
			join_table.shift
			@client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
		# @client = Twilio::REST::Client.new ENV['twilio_account_sid'], ENV['twilio_auth_token']
		r_hash = {}
		user_rest_hash ={}
		beginning_time = Time.now
		final_url_arr = []
		join_table[0].each do |row|
			url_arr = []
			@restaurant = Restaurant.find(row.restaurant_id)
			@user = User.find(row.user_id)
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
			my_hash = {};
			final_url_arr.each do |rest_url|
				url = rest_url
				doc = Nokogiri::HTML(open(url))
				y = doc.css("a.dtp-button.button").text.split(" PM")
				key = rest_url.split("=")[1].split("%")[0]
				my_hash.merge!("#{key}" => y)
			end
			r_hash[@restaurant.name] =  my_hash
	# if user_rest_hash[@user].nil?
	user_rest_hash[@user.id] = r_hash
	# else
	# user_rest_hash[@user].push()
	# end
	puts user_rest_hash
	end_time = Time.now
	puts "Time elapsed #{(end_time - beginning_time)*1000} milliseconds"
end
# final_hash = {}
user_rest_hash.each do |user_ids, rest_hash|
	final_hash = {}
	rest_hash.each do |restaurant, value|
		rest_id = Restaurant.find_by(name: restaurant).id
		start_time = CueRestaurant.find_by(restaurant_id:rest_id).start_time.hour
		end_time = CueRestaurant.find_by(restaurant_id:rest_id).end_time.hour
		value.each do |date, times|
			times.each do |time|
				if start_time.to_i <= (time.to_i + 12) && (time.to_i + 12) <= end_time.to_i
					puts "Hello World"
					if final_hash[restaurant].nil?
						final_hash[restaurant] = {"#{date}" => [time]}
					else
						unless final_hash[restaurant][date].nil?
							final_hash[restaurant][date].push(time)
						else
							final_hash[restaurant][date] = [time]
						end
					end
				end
			end
		end
	end
	puts final_hash
	puts @user
# @client = Twilio::REST::Client.new ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_AUTH_TOKEN"]
# @client = Twilio::REST::Client.new ENV["twilio_account_sid"], ENV["twilio_auth_token"]
# message = @client.account.messages.create(:body => "Please",
#      :from => "+16503993282",
#      :to => "+17277769719")
# puts message.to
if final_hash != {}
	restaurant_name = {}
	available_date = {}
	available_time = {}
	base_url = {}
	covers = {}
	final_url = {}

	user_join_table = join_table[0].group_by{|row| row.restaurant_id}
	restaurant_total = user_join_table.length
	counter = 1
	user_join_table.each do |user_join_table_row|
		user_join_table_row.shift
		first_available = user_join_table_row[0].first
		restaurant_name[counter] = Restaurant.find(first_available.restaurant_id).name
		if final_hash[Restaurant.find(first_available.restaurant_id).name].nil?
			available_date[counter] = "_"
			available_time[counter] = "_"
			base_url[counter] = Restaurant.find(first_available.restaurant_id).url.split("?")[0]
			covers[counter] = user_join_table_row[0].first.covers
			final_url[counter] = "No available reservations! Check back soon!"
			counter = counter + 1
		else
			available_date[counter] = final_hash[Restaurant.find(first_available.restaurant_id).name].keys.first
			available_time[counter] = final_hash[Restaurant.find(first_available.restaurant_id).name][available_date[counter]].first
			base_url[counter] = Restaurant.find(first_available.restaurant_id).url.split("?")[0]
			covers[counter] = user_join_table_row[0].first.covers
			final_url[counter] = base_url[counter] + "?DateTime=" + available_date[counter] + "%" + (available_time[counter].to_i + 12).to_s + (available_time[counter].to_i + 13).to_s + "&Covers=" + covers[counter]
			counter = counter + 1
		end
	end

	body_counter = restaurant_total
	url_list = ""
	while (body_counter > 0) do
		url_list = url_list + " " + "table at #{restaurant_name[body_counter]} for #{available_date[body_counter]} @ #{available_time[body_counter]}: #{final_url[body_counter]}" + " "
		body_counter = body_counter - 1
	end

	@client = Twilio::REST::Client.new ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_AUTH_TOKEN"]
# @client = Twilio::REST::Client.new ENV["twilio_account_sid"], ENV["twilio_auth_token"]
message = @client.account.messages.create(:body => "Hey #{@user.first_name}! Find your RezQ update below:
	#{url_list}",
	:from => "+16503993282",
	:to => "+1"+"#{@user.phone_number}")
puts message.to
end
end
end
end


def self.first_crawl cue_res
	join_table = [cue_res]
	@client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
		# @client = Twilio::REST::Client.new ENV['twilio_account_sid'], ENV['twilio_auth_token']
		r_hash = {}
		user_rest_hash ={}
		beginning_time = Time.now
		final_url_arr = []
		join_table.each do |row|
			url_arr = []
			@restaurant = Restaurant.find(row.restaurant_id)
			@user = User.find(row.user_id)
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
			my_hash = {};
			final_url_arr.each do |rest_url|
				url = rest_url
				doc = Nokogiri::HTML(open(url))
				y = doc.css("a.dtp-button.button").text.split(" PM")
				key = rest_url.split("=")[1].split("%")[0]
				my_hash.merge!("#{key}" => y)
			end
			r_hash[@restaurant.name] =  my_hash
	# if user_rest_hash[@user].nil?
	user_rest_hash[@user.id] = r_hash
	# else
	# user_rest_hash[@user].push()
	# end
	puts user_rest_hash
	end_time = Time.now
	puts "Time elapsed #{(end_time - beginning_time)*1000} milliseconds"
end
final_hash = {}
user_rest_hash.each do |user_ids, rest_hash|
	rest_hash.each do |restaurant, value|
		rest_id = Restaurant.find_by(name: restaurant).id
		start_time = CueRestaurant.find_by(restaurant_id:rest_id).start_time.hour
		end_time = CueRestaurant.find_by(restaurant_id:rest_id).end_time.hour
		value.each do |date, times|
			times.each do |time|
				if start_time.to_i <= (time.to_i + 12) && (time.to_i + 12) <= end_time.to_i
					puts "Hello World"
					if final_hash[restaurant].nil?
						final_hash[restaurant] = {"#{date}" => [time]}
					else
						unless final_hash[restaurant][date].nil?
							final_hash[restaurant][date].push(time)
						else
							final_hash[restaurant][date] = [time]
						end
					end
				end
			end
		end
	end
	puts final_hash
	puts @user
	if final_hash != {}
		restaurant_name = Restaurant.find(join_table[0].restaurant_id).name
		restaurant_id = Restaurant.find(join_table[0].restaurant_id).open_table_id
		available_date = final_hash[Restaurant.find(join_table[0].restaurant_id).name].keys.first
		available_date_split = final_hash[Restaurant.find(join_table[0].restaurant_id).name].keys.first.split("-")
		month = available_date_split[1]
		day = available_date_split[2]
		year = available_date_split[0]
		available_time = final_hash[Restaurant.find(join_table[0].restaurant_id).name][available_date].first
		hour = (available_time.split(":")[0].to_i + 12).to_s
		minute = available_time.split(":")[1]
		seperator = "%2F"
		# base_url for desktop below
		# base_url = @restaurant.url.split("?")[0]
		#base_url for mobile
		base_url = "https://m.opentable.com/reservation/details?"
		first_string = "&Points=100&PointsType=Standard&SlotHash=2221649544&SecurityID=0&DateTime="
		second_string = "&SlotLockID=377&OfferConfirmNumber=0&ChosenOfferId=0&IsMiddleSlot=True&ArePopPoints=False"
		covers = cue_res.covers
		final_url = base_url + "RestaurantID=" + restaurant_id + first_string + month + seperator + day + seperator + year + "%20" + hour + "%3A" + minute + "&PartySize=" + covers + second_string
		puts final_url
		# https://m.opentable.com/reservation/details?RestaurantID=7740&Points=100&PointsType=Standard&SlotHash=2221649544&SecurityID=0&DateTime=04%2F06%2F2015%2021%3A00%3A00&PartySize=4&SlotLockID=377&OfferConfirmNumber=0&ChosenOfferId=0&IsMiddleSlot=True&ArePopPoints=False
#"http://www.opentable.com/spqr-san-francisco?DateTime=2015-04-02%2122&Covers=2"
@client = Twilio::REST::Client.new ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_AUTH_TOKEN"]
# @client = Twilio::REST::Client.new ENV["twilio_account_sid"], ENV["twilio_auth_token"]
message = @client.account.messages.create(:body => "One or more restaurant reservations are currently available! Book your table at #{restaurant_name} for #{available_date} @ #{available_time} now: #{final_url}",
	:from => "+16503993282",
	:to => "+1"+"#{@user.phone_number}")
puts message.to
else
	@client = Twilio::REST::Client.new ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_AUTH_TOKEN"]
# @client = Twilio::REST::Client.new ENV["twilio_account_sid"], ENV["twilio_auth_token"]
message = @client.account.messages.create(:body => "All times are currently booked! Stay tuned, RezQ will let you know when a reservation becomes available!",
	:from => "+16503993282",
	:to => "+1"+"#{@user.phone_number}")
puts message.to
end
end
end
end