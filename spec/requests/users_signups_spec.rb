require 'rails_helper'

RSpec.describe "UsersSignups", type: :request do
  before do
    ActionMailer::Base.deliveries.clear
  end

  it "invalid signup information" do
    visit signup_path
    expect(page).to have_selector 'form[action="/signup"]'
    expect {
      fill_in "Email", with: "user@invalid"
      fill_in "Password", with: "foo"
      fill_in "Password confirmation", with: "bar"
      click_on "Create my account"
    }.to_not change {User.count}
    expect(page).to have_selector 'div#error_explanation'
    expect(page).to have_selector 'div.field_with_errors'
    expect(page).to have_selector 'div.alert'
    expect(page).to have_selector 'div.alert-danger'
  end

  it "valid signup information with account activation" do
    visit signup_path
    expect {
      fill_in "Name", with: "Example User"
      fill_in "Email", with: "user@example.com"
      fill_in "Password", with: "password"
      fill_in "Password confirmation", with: "password"
      click_on "Create my account"
    }.to change {User.count}.by(1)
    expect(ActionMailer::Base.deliveries.size).to eq(1)
    token = steal_token("account_activations")
    user = User.find_by(email: "user@example.com")
    expect(user).not_to be_activated
    # 有効化していない状態でログインしてみる
    log_in_as(user)
    expect(is_logged_in?).to be_falsey
    # 有効化トークンが不正な場合
    visit edit_account_activation_path("invalid token", email: user.email)
    expect(is_logged_in?).to be_falsey
    # トークンは正しいがメールアドレスが無効な場合
    visit edit_account_activation_path(token, email: 'wrong')
    expect(is_logged_in?).to be_falsey
    # 有効化トークンが正しい場合
    visit edit_account_activation_path(token, email: user.email)
    expect(user.reload).to be_activated
    expect(page).to have_selector 'div.alert-success'
    expect(is_logged_in?).to be_truthy
  end
end
