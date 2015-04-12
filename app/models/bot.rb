class Bot < ActiveRecord::Base
require 'rubygems'
require 'mechanize'
require 'logger'
require 'pry'
require "watir"

  def self.previous_reservation_check form_info, cue
    restaurant_id = Restaurant.where(name:form_info["restaurant_name"])[0].id
    cue_restaurant_rank = CueRestaurant.where(cue_id:cue.id).where(restaurant_id:restaurant_id)[0].rank
    if User.find(cue.user.id).reservations == []
      book_reservation form_info, cue, restaurant_id, cue_restaurant_rank
    else
      if cue_restaurant_rank < User.find(cue.user.id).reservations.where(cue_id:cue.id)[0].rank
        cancel_reservation User.find(cue.user.id).reservations.where(cue_id:cue.id)[0].reservation_url, cue.id, cue.user.id
        book_reservation form_info, cue, restaurant_id, cue_restaurant_rank
      end
    end
  end

  def self.book_reservation form_info, cue, restaurant_id, cue_restaurant_rank
    agent = Mechanize.new
    agent.log = Logger.new "mech.log"
    agent.user_agent_alias = 'Mac Safari'

    page = agent.get form_info["final_url"]

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
      confirmation_results = reservation_form.submit
      confirmation_results.body
      puts agent.page.uri.to_s

    if agent.page.uri.to_s != form_info["final_url"]

        Reservation.user_reservation agent.page.uri.to_s.split("Points")[0][0...-1], cue.user.id, cue.id, restaurant_id, cue_restaurant_rank
    else
      rest_url = optable_url agent.page.uri.to_s

      Email.error_email form_info, cue.id, rest_url
    end
  end

  def self.cancel_reservation url, cue_id, user_id
    browser = Watir::Browser.new :chrome
    browser.goto url
    browser.link(:id, "CancelButton").when_present.click
    puts "hello"
    browser.button(:id, "dynamicDialogYes").when_present.click
    puts "fin"
    Reservation.remove_reservation url, cue_id, user_id

  end

  def self.optable_url url
    browser = Watir::Browser.new :chrome
    browser.goto url
    browser.link(:id, "btnCancel").when_present.click
    puts "fin"
    browser.url
  end

end
