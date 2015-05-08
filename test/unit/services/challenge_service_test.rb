# encoding: UTF-8

require 'test_helper'

class ChallengeServiceTest < ActiveSupport::TestCase
    include ChallengeService

    test "test get_found_users" do
        users = get_found_users("a")
        assert_equal users.length, 1
        assert_equal users[0], users(:martin)

        assert get_found_users("y").length == 0

        users = get_found_users("n")
        assert_equal users.length, 2
        assert_equal users[0], users(:bruno)
        assert_equal users[1], users(:martin)
    end

    test "test get_suggested_users" do
        users = get_suggested_users
        assert_equal users.length, 2
        assert_equal users[0], users(:martin)
        assert_equal users[1], users(:bruno)
    end

    test "test is_sender?" do
        assert is_sender?(challenges(:pending_pending), users(:martin))
        assert !is_sender?(challenges(:pending_pending), users(:bruno))
        assert !is_sender?(challenges(:nil_users), users(:martin))
        assert !is_sender?(challenges(:pending_pending), nil)
        assert !is_sender?(nil, users(:martin))
        assert !is_sender?(nil, nil)
    end

    test "test is_receiver?" do
        assert is_receiver?(challenges(:pending_pending), users(:bruno))
        assert !is_receiver?(challenges(:pending_pending), users(:martin))
        assert !is_receiver?(challenges(:nil_users), users(:martin))
        assert !is_receiver?(challenges(:pending_pending), nil)
        assert !is_receiver?(nil, users(:martin))
        assert !is_receiver?(nil, nil)
    end

    test "test challenge_pending_exists?" do
        assert challenge_pending_exists?(users(:martin), users(:bruno))
        assert !challenge_pending_exists?(users(:bruno), users(:martin))
        assert !challenge_pending_exists?(users(:martin), nil)
        assert !challenge_pending_exists?(nil, users(:martin))
        assert !challenge_pending_exists?(nil, nil)
    end

    test "test is_pending?" do
        assert is_pending?(challenges(:pending_pending))
        assert !is_pending?(challenges(:accepted_accepted))
        assert !is_pending?(challenges(:pending_refused))
        assert !is_pending?(challenges(:playing_accepted))
        assert !is_pending?(challenges(:playing_playing))
        assert !is_pending?(challenges(:finished_playing))
        assert !is_pending?(challenges(:finished_finished))
        assert !is_pending?(challenges(:finished_withdrawn))
    end

    test "test is_sender_finished?" do
        assert !is_sender_finished?(challenges(:pending_pending))
        assert !is_sender_finished?(challenges(:accepted_accepted))
        assert !is_sender_finished?(challenges(:pending_refused))
        assert !is_sender_finished?(challenges(:playing_accepted))
        assert !is_sender_finished?(challenges(:playing_playing))
        assert is_sender_finished?(challenges(:finished_playing))
        assert is_sender_finished?(challenges(:finished_finished))
        assert is_sender_finished?(challenges(:finished_withdrawn))
    end

    test "test is_receiver_finished?" do
        assert !is_receiver_finished?(challenges(:pending_pending))
        assert !is_receiver_finished?(challenges(:accepted_accepted))
        assert !is_receiver_finished?(challenges(:pending_refused))
        assert !is_receiver_finished?(challenges(:playing_accepted))
        assert !is_receiver_finished?(challenges(:playing_playing))
        assert !is_receiver_finished?(challenges(:finished_playing))
        assert is_receiver_finished?(challenges(:finished_finished))
        assert !is_receiver_finished?(challenges(:finished_withdrawn))
    end

    test "test save_accepted" do
        assert save_accepted(challenges(:pending_pending))
        assert_equal challenges(:pending_pending).sender_status, "accepted"
        assert_equal challenges(:pending_pending).receiver_status, "accepted"
    end

    test "test save_refused" do
        assert save_refused(challenges(:pending_pending))
        assert_equal challenges(:pending_pending).sender_status, "refused"
        assert_equal challenges(:pending_pending).receiver_status, "refused"
    end

    test "test save_withdraw sender" do
        assert save_withdraw(challenges(:playing_playing), users(:martin))
        assert_equal challenges(:playing_playing).sender_status, "withdrawn"
        assert_equal challenges(:playing_playing).receiver_status, "playing"
    end

    test "test save_withdraw receiver" do
        assert save_withdraw(challenges(:playing_playing), users(:bruno))
        assert_equal challenges(:playing_playing).sender_status, "playing"
        assert_equal challenges(:playing_playing).receiver_status, "withdrawn"
    end

    test "test save_withdraw invalid" do
        assert !save_withdraw(challenges(:pending_pending), users(:martin))
        assert_equal challenges(:pending_pending).sender_status, "pending"
        assert_equal challenges(:pending_pending).receiver_status, "pending"
    end
end