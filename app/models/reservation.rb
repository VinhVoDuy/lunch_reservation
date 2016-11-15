class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :dish
  before_create :compute_amount, on: :create
  validate :before_5_pm
  validates_presence_of :user, :dish
  before_destroy :check_time

  def compute_amount
    self.amount = dish.price * (1 - (user.discount / 100.0))
  end

  def before_5_pm
    errors.add(:base, 'Booking after 5:00 PM is not allowed') if invalid_time?
  end

  def invalid_time?
    Time.now > Time.new(dish.date.year, dish.date.month, dish.date.day, 17)
  end

  def check_time
    if invalid_time?
      errors.add(:base, 'Cancellation after 5:00 PM is not allowed')
      throw(:abort)
    end
  end

end
