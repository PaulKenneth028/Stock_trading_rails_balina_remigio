# app/models/user.rb
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, uniqueness: true, presence: true
  validates :first_name, :last_name, presence: true

  before_create :set_starting_balance

  private

  def set_starting_balance
    # Set starting balance only if the user is not an admin
    self.balance = 5000 unless admin?
  end
end
