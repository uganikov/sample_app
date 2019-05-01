require 'rails_helper'

RSpec.describe "UsersLogins", type: :request do
  let(:user) { users(:michael) }

  it "login with invalid information" do
    visit login_path
    click_on "commit"
    expect(page).to have_selector ".alert-danger"
    visit root_path
    expect(page).not_to have_selector ".alert-danger"
  end

  it "login with valid information followed by logout" do
    visit login_path
    fill_in "Email", with: user.email
    fill_in "Password", with: 'password'
    click_on "commit"
    expect(is_logged_in?).to be_truthy
    expect(page.current_url).to eq user_url(user)
    expect(page).not_to have_selector "a[href='#{login_path}']"
    expect(page).to have_selector "a[href='#{logout_path}']" 
    expect(page).to have_selector "a[href='#{user_path(user)}']"
    click_on "Log out"
    expect(is_logged_in?).to be_falsey
    expect(page.current_url).to eq root_url

    # 2番目のウィンドウでログアウトをクリックするユーザーをシミュレートする
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(user), count: 0
  end

  it "login with remembering" do
    log_in_as(user, remember_me: '1')
    token = Capybara.current_session.driver.request.cookies.[]('remember_token')
    expect(user.reload).to be_authenticated("remember", token)
  end

  it "login without remembering" do
    # クッキーを保存してログイン
    log_in_as(user, remember_me: true)
    expect(Capybara.current_session.driver.request.cookies.[]('remember_token')).not_to be_empty
    click_on "Log out"
    # クッキーを削除してログイン
    log_in_as(user, remember_me: false)
    expect(Capybara.current_session.driver.request.cookies.[]('remember_token')).to be_nil
  end
end
