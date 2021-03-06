require 'test_helper'

class ChallengeTest < ActiveSupport::TestCase

  test "status validation" do
    challenge = Challenge.new(sender: users(:martin), receiver: users(:bruno), sender_status: "pending", receiver_status: "pending")
    assert challenge.save
    challenge = Challenge.new(sender: users(:martin), receiver: users(:bruno), sender_status: "accepted", receiver_status: "pending")
    assert challenge.save
    challenge = Challenge.new(sender: users(:martin), receiver: users(:bruno), sender_status: "refused", receiver_status: "pending")
    assert challenge.save
    challenge = Challenge.new(sender: users(:martin), receiver: users(:bruno), sender_status: "playing", receiver_status: "pending")
    assert challenge.save
    challenge = Challenge.new(sender: users(:martin), receiver: users(:bruno), sender_status: "finished", receiver_status: "pending")
    assert challenge.save
    challenge = Challenge.new(sender: users(:martin), receiver: users(:bruno), sender_status: "withdrawn", receiver_status: "pending")
    assert challenge.save
    challenge = Challenge.new(sender: users(:martin), receiver: users(:bruno), sender_status: "pending", receiver_status: "accepted")
    assert challenge.save
    challenge = Challenge.new(sender: users(:martin), receiver: users(:bruno), sender_status: "pending", receiver_status: "refused")
    assert challenge.save
    challenge = Challenge.new(sender: users(:martin), receiver: users(:bruno), sender_status: "pending", receiver_status: "playing")
    assert challenge.save
    challenge = Challenge.new(sender: users(:martin), receiver: users(:bruno), sender_status: "pending", receiver_status: "finished")
    assert challenge.save
    challenge = Challenge.new(sender: users(:martin), receiver: users(:bruno), sender_status: "pending", receiver_status: "withdrawn")
    assert challenge.save
    challenge = Challenge.new(sender: users(:martin), receiver: users(:bruno), sender_status: "invalid", receiver_status: "pending")
    assert !challenge.save
    challenge = Challenge.new(sender: users(:martin), receiver: users(:bruno), sender_status: "pending", receiver_status: "invalid")
    assert !challenge.save
  end

  test "winner" do
    assert_nil challenges(:pending_pending).winner
    assert_nil challenges(:accepted_accepted).winner
    assert_nil challenges(:pending_refused).winner
    assert_nil challenges(:playing_accepted).winner
    assert_nil challenges(:playing_playing).winner
    assert_nil challenges(:finished_playing).winner
    assert_equal challenges(:finished_finished).winner, users(:martin)
    assert_equal challenges(:finished_withdrawn).winner, users(:martin)
  end
end
