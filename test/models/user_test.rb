# test/models/user_test.rb
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "should save a valid user" do
    user = User.new(
      email: 'unique_email@example.com',  # Use a unique email address
      password: 'password123',
      password_confirmation: 'password123',
      first_name: 'John',
      last_name: 'Doe'
    )
    assert user.valid?, "Failed to save a valid user: #{user.errors.full_messages.join(', ')}"
    assert user.save, "Failed to save a valid user"
  end

  test "should not save a user without an email" do
    user = User.new(
      password: 'password123',
      password_confirmation: 'password123',
      first_name: 'John',
      last_name: 'Doe'
    )
    assert_not user.valid?, "User without an email should be invalid"
    assert_not user.save, "Saved the user without an email"
  end

  test "should not save a user without a first name" do
    user = User.new(
      email: 'unique_email@example.com',  # Use a unique email address
      password: 'password123',
      password_confirmation: 'password123',
      last_name: 'Doe'
    )
    assert_not user.valid?, "User without a first name should be invalid"
    assert_not user.save, "Saved the user without a first name"
  end

  test "should not save a user without a last name" do
    user = User.new(
      email: 'unique_email@example.com',  # Use a unique email address
      password: 'password123',
      password_confirmation: 'password123',
      first_name: 'John'
    )
    assert_not user.valid?, "User without a last name should be invalid"
    assert_not user.save, "Saved the user without a last name"
  end

  test "should send approval email after status change to approved" do
    user = users(:example_user)  

   
    assert_equal 'pending', user.status

    # Changing the status to approved
    user.update(status: :approved)

    # Check if the approval email was sent
    assert_emails 1 do
      # Any action that triggers the approval email
      # e.g., user.save
    end
  end
end
