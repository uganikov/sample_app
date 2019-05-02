require 'rails_helper'

RSpec.describe "PasswordResets", type: :request do
  let(:user) { users(:michael) }

  before do
    ActionMailer::Base.deliveries.clear
  end

  it "password resets" do
    visit new_password_reset_url
    # メールアドレスが無効
    click_on "Submit"
    expect(page).to have_selector "div.alert-danger"
    expect(page.current_url).to eq password_resets_url
    # メールアドレスが有効
    fill_in "Email", with: user.email
    click_on "Submit"
    expect(user.reset_digest).not_to eq(user.reload.reset_digest)
    expect(ActionMailer::Base.deliveries.size).to eq 1
    expect(page).to have_selector "div.alert-info"
    expect(page.current_url).to eq root_url
    token = steal_token("password_resets")
    # パスワード再設定フォームのテスト
    # メールアドレスが無効
    visit edit_password_reset_path(token, email: "")
    expect(page.current_url).to eq root_url
    # 無効なユーザー
    user.toggle!(:activated)
    visit edit_password_reset_path(token, email: user.email)
    expect(page.current_url).to eq root_url
    user.toggle!(:activated)
    # メールアドレスが有効で、トークンが無効
    visit edit_password_reset_path('wrong token', email: user.email)
    expect(page.current_url).to eq root_url
    # メールアドレスもトークンも有効
    visit edit_password_reset_path(token, email: user.email)
    expect(page.current_url).not_to eq root_url
    expect(page).to have_selector "input[name=email][value='#{user.email}']", visible: false
    # パスワードが空
    click_on "Update password"
    expect(page).to have_selector 'div#error_explanation'
    # 無効なパスワードとパスワード確認
    fill_in "Password", with: "foobaz"
    fill_in "Confirmation", with: "barquux"
    click_on "Update password"
    expect(page).to have_selector 'div#error_explanation'
    # 有効なパスワードとパスワード確認
    fill_in "Password", with: "foobaz"
    fill_in "Confirmation", with: "foobaz"
    click_on "Update password"
    expect(page).to have_selector "div.alert-success"
    expect(is_logged_in?).to be_truthy
    expect(page.current_url).to eq user_url(user)
    expect(user.reload.reset_digest).to be_nil
  end

  it "expired token" do
    visit new_password_reset_url
    fill_in "Email", with: user.email
    click_on "Submit"
    token = steal_token("password_resets")
    visit edit_password_reset_path(token, email: user.email)
    user.update_attribute(:reset_sent_at, 3.hours.ago)
    fill_in "Password", with: "foobaz"
    fill_in "Confirmation", with: "foobaz"
    click_on "Update password"
    expect(page.current_url).to eq new_password_reset_url
    expect(page).to have_selector "div.alert-danger", text: /expired/i
  end
end
