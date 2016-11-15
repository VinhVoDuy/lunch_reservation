class Dish < ApplicationRecord
  attr_accessor :names
  validates_presence_of :name, :price, :date
  scope :this_week, -> { where('date >= :start_week AND date <= :end_week', start_week: Time.now.beginning_of_week, end_week: Time.now.end_of_week) }
  scope :next_week, -> { where('date >= :start_week AND date <= :end_week', start_week: (Time.now.beginning_of_week + 1.week), end_week: (Time.now.end_of_week + 1.week)) }
  scope :previous_week, -> { where('date >= :start_week AND date <= :end_week', start_week: (Time.now.beginning_of_week - 1.week), end_week: (Time.now.end_of_week - 1.week)) }
  scope :today, -> { where(date: Date.today) }
  has_many :reservations, dependent: :destroy
  has_many :users, through: :reservations
end
