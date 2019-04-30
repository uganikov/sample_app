require 'rails_helper'

RSpec.describe "UsersEdits", type: :request do
  let(:user) { users(:michael) }

  it "unsuccessful edit" do
    log_in_as(user)
    get edit_user_path(user)
    assert_template 'users/edit'
    patch user_path(user), params: { user: { name:  "",
                                              email: "foo@invalid",
                                              password:              "foo",
                                              password_confirmation: "bar" } }

    assert_template 'users/edit'
    assert_select "div", "The form contains 4 errors."
  end

  it "successful edit" do
    log_in_as(user)
    get edit_user_path(user)
    assert_template 'users/edit'
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
    expect(flash.empty?).to be_falsey
    assert_redirected_to user
    user.reload
    assert_equal name,  user.name
    assert_equal email, user.email
  end

  it "successful edit with friendly forwarding" do
    get edit_user_path(user)
    assert_equal session[:forwarding_url], edit_user_url(user)
    log_in_as(user)
    assert_redirected_to edit_user_url(user)
    expect(session[:forwarding_url]).to be_falsey
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
    expect(flash.empty?).to be_falsey
    assert_redirected_to user
    user.reload
    assert_equal name,  user.name
    assert_equal email, user.email
  end
end
