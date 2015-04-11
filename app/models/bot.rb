class Bot < ActiveRecord::Base
require 'rubygems'
require 'mechanize'
require 'logger'
require 'pry'

  def self.book_reservation form_info
    binding.pry
  agent = Mechanize.new
  agent.log = Logger.new "mech.log"
  agent.user_agent_alias = 'Mac Safari'

  page = agent.get form_info["final_url"]

  # "https://m.opentable.com/reservation/details?RestaurantID=7740&Points=100&PointsType=Standard&SecurityID=1800214996&DateTime=04%2F22%2F2015%2021%3A30%3A00&ResultsKey=x%252be08K0%252f5NqM9qy%252ba2%252b3kA%253d%253d&PartySize=2&SlotLockID=6216&OfferConfirmNumber=0&ChosenOfferId=0&IsMiddleSlot=False&ArePopPoints=False"

  reservation_form = page.forms.first

  reservation_form["FirstName"] = form_info["first_name"] #"George"
  reservation_form["LastName"] = form_info["last_name"] #"Navas"
  reservation_form["Email"] = form_info["email"] #"gannavas@gmail.com"
  reservation_form["MetroId"] = form_info["metro_id"] #"4"
  reservation_form["PhoneNumber"] = form_info["phone_number"] #"7277769719"
  reservation_form["SpecialInstructions"] = ""
  reservation_form["RestaurantName"] = form_info["restaurant_name"]   #"Slanted Door"
  reservation_form["FormattedDateTime"] = form_info["first_date"] #Wed 4/22/2015 9:30 PM"
  reservation_form["GuestText"] = "+ #{form_info["covers"].to_i - 1} guest(s)"    #"+ 1 guest(s)"
  reservation_form["OffersCsv"] = ""
  reservation_form["ChosenOfferVersion"] = "0"
  reservation_form["IsJustRegistered"] = "False"
  reservation_form["IsForeignGuest"] = "False"
  reservation_form["FormattedReservationDate:"] = form_info["second_date"] #"Wednesday, April 22"
  reservation_form["FormattedReservationTimePartySize"] = form_info["third_date"] #"9:30 PM for 2 people"
  binding.pry
  confirmation_results = reservation_form.submit

  confirmation_results.body
  binding.pry
  puts agent.page.uri.to_s
  agent.page.uri.to_s.split("Points")[0][0...-1]
  binding.pry


  end

end
