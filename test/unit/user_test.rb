require 'test_helper'

class UserTest < ActiveSupport::TestCase

  # ========= Account creation ==========

  test "should save valid user" do
    user = User.new
    user.pseudo = "test"
    user.email = "test@test.te"
    user.password = "test"
    user.password_confirmation = "test"
    assert user.save, "Saved the user"
  end

  test "should not save user without email" do
    user = User.new
    user.pseudo = "test"
    user.password = "test"
    user.password_confirmation = "test"
    assert !user.save, "Saved the user without an email"
  end

  test "should not save user without pseudo" do
    user = User.new
    user.email = "test@test.test"
    user.password = "test"
    user.password_confirmation = "test"
    assert !user.save, "Saved the user without a pseudo"
  end

  test "should not save user without password" do
    user = User.new
    user.pseudo = "test"
    user.email = "test@test.test"
    user.password_confirmation = "test"
    assert !user.save, "Saved the user without a password"
  end

  test "should not save user with invalid email" do
    user = User.new
    user.pseudo = "Test"
    user.email = "invalid"
    user.password = "test"
    user.password_confirmation = "test"
    assert !user.save, "Saved the user with invalid email"
  end

  test "should not save user with invalid password confirmation" do
    user = User.new
    user.pseudo = "Test"
    user.email = "test@test.te"
    user.password = "test"
    user.password_confirmation = "invalid"
    assert !user.save, "Saved the user with invalid password confirmation"
  end

  test "should not save user with existing pseudo" do
    martin = User.find_by_pseudo("Martin")
    assert_not_nil martin
    user = User.new
    user.pseudo = "Martin"
    user.email = "test1@test.te"
    user.password = "test"
    user.password_confirmation = "test"
    assert !user.save, "Saved the user with existing pseudo"
  end

  test "should not save user with existing email" do
    martin = User.find_by_email("salles.martin@gmail.com")
    assert_not_nil martin
    user = User.new
    user.pseudo = "testtest"
    user.email = "salles.martin@gmail.com"
    user.password = "test"
    user.password_confirmation = "test"
    assert !user.save, "Saved the user with existing email"
  end

  # ========= Account authentication ==========

  test "authenticate_by_pseudo" do
    user = User.authenticate_by_pseudo(users(:martin).pseudo, "test")
    assert_not_nil user
    user = User.authenticate_by_pseudo(users(:martin).pseudo, "invalid")
    assert_nil user
    user = User.authenticate_by_pseudo("invalid", "test")
    assert_nil user
  end

  test "authenticate_by_email" do
    user = User.authenticate_by_email(users(:martin).email, "test")
    assert_not_nil user
    user = User.authenticate_by_email(users(:martin).email, "invalid")
    assert_nil user
    user = User.authenticate_by_email("test@test.te", "test")
    assert_nil user
  end

  # ========= Account SinglePlayerGames ==========

  test "singleplayergames list" do
    games = users(:martin).singleplayer_games
    assert_equal games.count, 2
    assert_equal single_player_games(:lost), games[0]
    assert_equal single_player_games(:won), games[1]
  end

  test "singleplayergames finished list" do
    games = users(:martin).singleplayer_games_finished
    assert_equal games.count, 1
    assert_equal single_player_games(:won), games[0]
  end

  test "singleplayergames playing list" do
    games = users(:martin).singleplayer_games_playing
    assert_equal games.count, 1
    assert_equal single_player_games(:lost), games[0]
  end

  # ========= Account Statistics ==========

  test "singleplayer_victories_nb" do
    assert_equal users(:martin).singleplayer_victories_nb, 1
    assert_equal users(:bruno).singleplayer_victories_nb, 0
  end

  test "singleplayer_games_nb" do
    assert_equal users(:martin).singleplayer_games_nb, 2
    assert_equal users(:bruno).singleplayer_games_nb, 0
  end

  test "singleplayer_average_victory_duration" do
    assert_equal users(:martin).singleplayer_average_victory_duration, 120
    assert_equal users(:bruno).singleplayer_average_victory_duration, -1
  end

  test "singleplayer_victories_rate" do
    assert_equal users(:martin).singleplayer_victories_rate, 0.5
    assert_equal users(:bruno).singleplayer_victories_rate, -1
  end

end
