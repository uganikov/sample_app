require 'rails_helper'

RSpec.describe "layout links", type: :request do
  let(:user) { users(:michael) }

  describe "GET /" do
    it "works! (now write some real specs)" do
      get root_path
      expect(response).to have_http_status(200)
      assert_template 'static_pages/home'
      assert_select "a[href=?]", root_path, count: 2
      assert_select "a[href=?]", help_path
      assert_select "a[href=?]", about_path
      assert_select "a[href=?]", contact_path
      assert_select "a[href=?]", login_path
    end

    it "works! (now write some real specs)" do
      log_in_as(user)
      get root_path
      expect(response).to have_http_status(200)
      assert_template 'static_pages/home'
      assert_select "a[href=?]", users_path
      assert_select "a[href=?]", user_path(user)
      assert_select "a[href=?]", edit_user_path(user)
      assert_select "a[href=?]", logout_path
      assert_select 'strong.stat', count: 2
      get contact_path
      assert_select "title", full_title("Contact")
      get signup_path
      assert_select "title", full_title("Sign up")
    end
  end
end
