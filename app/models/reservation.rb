class Reservation < ActiveRecord::Base
  belongs_to :user

  def self.user_reservation url, user_id, cue_id, restaurant_id, restaurant_rank
    binding.pry
    Reservation.create(user_id:user_id, cue_id:cue_id, restaurant_id:restaurant_id, rank:restaurant_rank, reservation_url:url)
  end

  def self.remove_reservation url, cue_id, user_id
    binding.pry
    User.find(user_id).reservations.where(reservation_url: url).where(cue_id: cue_id)[0].destroy

  end
end
