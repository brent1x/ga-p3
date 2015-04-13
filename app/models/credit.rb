require 'rubygems'
require 'mechanize'
require 'logger'
require 'pry'

agent = Mechanize.new
agent.log = Logger.new "mech.log"
agent.user_agent_alias = 'Mac Safari'

page = agent.get "https://m.opentable.com/reservation/details?RestaurantID=7740&Points=100&PointsType=Standard&SlotHash=2221649544&SecurityID=0&DateTime=04%2F06%2F2015%2021%3A00%3A00&PartySize=4&SlotLockID=377&OfferConfirmNumber=0&ChosenOfferId=0&IsMiddleSlot=True&ArePopPoints=False"

reservation_form = page.forms.first

puts reservation_form
reservation_form.fields.each do |x|
end
y = page.forms.last
puts y

reservation_form["RestaurantID"] = "35785"
reservation_form["Points"] = "100"
reservation_form["PointsType"] = "Standard"
reservation_form["SlotHash"] = "1470282458"
reservation_form["SecurityID"] = "0"
reservation_form["DateTime"] = "04/11/2015 22:00:00"
reservation_form["PartySize"] = "2"
reservation_form["SlotLockID"] = "340"
reservation_form["OfferConfirmNumber"] = "0"
reservation_form["ChosenOfferId"] = "0"
reservation_form["IsMiddleSlot"] = "True"
reservation_form["ArePopPoints"] = "False"
reservation_form["ExpireMonth"] = "05"
reservation_form["ExpireYear"] = "2016"
reservation_form["Last4"] = "1973"


confirmation_results = reservation_form.submit

puts confirmation_results.body
