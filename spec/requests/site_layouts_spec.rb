require 'rails_helper'

RSpec.describe "layout links", type: :request do
  let(:user) { users(:michael) }

  describe "GET /" do
    it "works! (now write some real specs)" do
      visit root_path
      expect(page).to have_http_status(:success)
      expect(page).to have_selector "a[href='#{root_path}']", count: 2
      expect(page).to have_selector "a[href='#{help_path}']"
      expect(page).to have_selector "a[href='#{about_path}']"
      expect(page).to have_selector "a[href='#{contact_path}']"
      expect(page).to have_selector "a[href='#{login_path}']"
    end

    it "works! (now write some real specs)" do
      log_in_as(user)
      visit root_path
      expect(page).to have_http_status(:success)
      expect(page).to have_selector "a[href='#{users_path}']"
      expect(page).to have_selector "a[href='#{user_path(user)}']"
      expect(page).to have_selector "a[href='#{edit_user_path(user)}']"
      expect(page).to have_selector "a[href='#{logout_path}']"
      expect(page).to have_selector 'strong.stat', count: 2
      visit contact_path
      expect(page).to have_title full_title("Contact")
      visit signup_path
      expect(page).to have_title full_title("Sign up")
    end
  end
end
