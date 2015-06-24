require 'test_helper'
 
class AuthenticationTest < ActionDispatch::IntegrationTest
  # Use fixtures data vendors and clients
  fixtures :users
  
  test "signup login and browse site" do
    # login via https
    https!

    # can't acces user stats if not logged in
    get_via_redirect "/statistics"
    assert_response :success
    assert_equal '/', path
    assert_equal 'You must be signed in to view that page.', flash[:error]

    # got to signup page
    get "/signup"
    assert_response :success
    assert_equal '/signup', path

    #sign up failed stays on page
    post_via_redirect "/signup", user: { pseudo: "aaa", email: "test@test.te", password: ""}
    assert_response :success
    assert_equal '/signup', path

    #sign up
    post_via_redirect "/signup", user: { pseudo: "aaa", email: "test@test.te", password: "bbb"}
    assert_response :success
    assert_equal '/', path
    assert_equal 'Signed up!', flash[:notice]
 
    # wrong login stays on page with message
    post_via_redirect "/login", user: { pseudo: "aaaaa", password: "aaaa"}
    assert_response :success
    assert_equal 'Invalid pseudo or password', flash[:alert]
    assert_equal '/login', path
 
    # login
    post_via_redirect "/login", user: { pseudo: "aaa", password: "bbb"}
    assert_response :success
    assert_equal '/', path
    assert_equal 'Logged in!', flash[:notice]
 
    # statistics page
    get "/statistics"
    assert_response :success
    assert_equal '/statistics', path

    # log out
    get_via_redirect "/logout"
    assert_response :success
    assert_equal '/', path
    assert_equal 'Logged out!', flash[:notice]

    # can't acces user stats if not logged in
    get_via_redirect "/statistics"
    assert_response :success
    assert_equal '/', path
    assert_equal 'You must be signed in to view that page.', flash[:error]
  end

  test "forgotten password flow" do
    # got to login page
    get "/login"
    assert_response :success
    assert_equal '/login', path

    # got to forgot password page
    get "/forgot_password"
    assert_response :success
    assert_equal '/forgot_password', path

    # fill forgot password form
    put_via_redirect "/forgot_password", user: { email: users(:martin).email }
    assert_response :success
    assert_equal '/login', path
    assert_equal "Password instructions have been mailed to you. Please check your inbox.", flash[:notice]

    martin = User.find_by_pseudo(users(:martin).pseudo)

    # got to password reset page
    get "/password_reset", martin.password_reset_token
    assert_response :success
    assert_equal '/password_reset', path

    # fill password reset form
    put_via_redirect "/password_reset", user: {
        pseudo: martin.pseudo,
        email: martin.email,
        new_password: "aaaa",
        new_password_confirmation: "aaaa",
    }
    assert_response :success
    assert_equal '/login', path
    assert_equal "Your password has been reset. Please sign in with your new password.", flash[:notice]

    # login with new password
    post_via_redirect "/login", user: { pseudo: martin.pseudo, password: "aaaa"}
    assert_response :success
    assert_equal '/', path
    assert_equal 'Logged in!', flash[:notice]
  end
end