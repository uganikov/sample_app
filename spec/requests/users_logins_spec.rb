require 'rails_helper'

RSpec.describe "UsersLogins", type: :request do
  let(:user) { users(:michael) }

  it "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: "" } }
    assert_template 'sessions/new'
    expect(flash.empty?).to be_falsey
    get root_path
    expect(flash.empty?).to be_truthy
  end

  it "login with valid information followed by logout" do
    get login_path
    post login_path, params: { session: { email:    user.email,
                                          password: 'password' } }
    assert is_logged_in?
    assert_redirected_to user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(user)
    delete logout_path
    expect(is_logged_in?).to be_falsey
    assert_redirected_to root_url
    # 2番目のウィンドウでログアウトをクリックするユーザーをシミュレートする
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(user), count: 0
  end

  it "login with remembering" do
    log_in_as(user, remember_me: '1')
    assert_equal cookies['remember_token'], assigns(:user).remember_token
  end

  it "login without remembering" do
    # クッキーを保存してログイン
    log_in_as(user, remember_me: '1')
    delete logout_path
    # クッキーを削除してログイン
    log_in_as(user, remember_me: '0')
    assert_empty cookies['remember_token']
  end
end
