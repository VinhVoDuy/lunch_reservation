class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :user_type
  validates_presence_of :user_type
  delegate :discount, to: :user_type
  has_many :reservations, dependent: :destroy
  has_many :deposits, dependent: :destroy
  before_validation :set_user_type, on: :create, unless: :user_type
  def set_user_type
    if email.split('@').last == '2359media.com'
      self.user_type = UserType.find_by_name('Employee')
    else
      self.user_type = UserType.find_by_name('Guest')
    end
  end
end
