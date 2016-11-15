class Deposit < ApplicationRecord
  belongs_to :user
  validates_presence_of :user, :amount
end
