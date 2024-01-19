class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, uniqueness: true, presence: true
  validates :first_name, :last_name, presence: true

  before_create :set_starting_balance
  after_update :send_approval_email, if: :status_changed?

  enum status: [:pending, :approved]

  has_many :user_stocks
  has_many :stocks, through: :user_stocks

  private

  def set_starting_balance
    self.balance = 5000 unless admin?
  end

  def check_approval_status
    self.status = :pending unless admin_approved?
  end

  def send_approval_email
    if approved?
      UserMailer.account_approved(self).deliver_now
    end
  end
end