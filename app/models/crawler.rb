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
	def self.get_rest
		x = Restaurant.all
			puts x["name"]
	end

	def self.crawler_check
		join_table = CueRestaurant.all
		@client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
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
					if start_time.to_i <= (time.to_i + 12) && (time.to_i + 12) >= end_time.to_i
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
@client = Twilio::REST::Client.new ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_AUTH_TOKEN"]
message = @client.account.messages.create(:body => "Please",
     :from => "+16503993282",
     :to => "+17277769719")
puts message.to

	end
	end
end