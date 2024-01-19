# test/mailers/user_mailer_test.rb
require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test 'account_approved sends email' do
    user = users(:one)  # Replace with a valid user from your fixtures or create a user for testing
    email = UserMailer.account_approved(user).deliver_now

    assert_not ActionMailer::Base.deliveries.empty?

    assert_equal ['from@example.com'], email.from
    assert_equal [user.email], email.to
    assert_equal 'Your account has been approved!', email.subject
    assert_match 'Your account has been approved', email.body.to_s
  end
end
