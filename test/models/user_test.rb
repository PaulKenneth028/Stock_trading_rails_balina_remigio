require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "should save a valid user" do
    user = User.new(
      email: 'unique_email@example.com',  # Use a unique email address
      password: 'password123',
      password_confirmation: 'password123'
    )
    assert user.valid?, "Failed to save a valid user: #{user.errors.full_messages.join(', ')}"
    assert user.save, "Failed to save a valid user"
  end

  test "should not save a user without an email" do
    user = User.new(
      password: 'password123',
      password_confirmation: 'password123'
    )
    assert_not user.valid?, "User without an email should be invalid"
    assert_not user.save, "Saved the user without an email"
  end
end
