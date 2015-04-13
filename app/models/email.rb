class Email
require 'mandrill'
mandrill = Mandrill::API.new ENV["MANDRIL_APIKEY"]

  def self.error_email form_info, cue_id, rest_url
    @user = User.find_by(email: form_info["email"])
    require 'mandrill'
    m = Mandrill::API.new
      message = {                                                       # this is the function which sends an email from within the app.
       :subject=> "RezQ Update: error while booking your reservation.",
       :from_name=> "The RezQ Team",
       :text=>"Error Notification",
       :to=> [email:form_info["email"]],
       :html=>"<html> <h2>Hello #{form_info["first_name"]},</h2>
       <h4>There was an error while trying to book your reservation for #{form_info["restaurant_name"]}.
       These errors are often associated with a credit card being required to complete the reservation.
       Please visit the following link to complete your reservation for #{form_info["restaurant_name"]} on #{form_info["second_date"]} : <a href=#{rest_url}> #{form_info["restaurant_name"]} </a></h4>
       <h4>Please note - you will also need to cancel any preexisting reservations that may currently be booked within the queue here: <a href=http://rezq.co/cues/#{cue_id}>Cancel Reservation</a>.
       If errors persists, please delete this restaurant from your queue: #{Cue.find(cue_id).name} and/or reach out to the RezQ team @ rezqnoreply@gmail.com.</h4>
      <h2>Thanks - The RezQ Team </h2>
       </html>",
       :from_email=>"rezqnoreply@gmail.com"
      }
    sending = m.messages.send message
    puts sending
  end
end