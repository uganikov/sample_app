require 'rails_helper'

RSpec.describe "UsersEdits", type: :request do
  let(:user) { users(:michael) }

  it "unsuccessful edit" do
    log_in_as(user)
    visit edit_user_path(user)
    fill_in "Name", with: ""
    fill_in "Email", with: "foo@invalid"
    fill_in "Password", with: "foo"
    fill_in "Password confirmation", with: "bar"
    click_on "commit"
    expect(page).to have_selector "div", text: "The form contains 4 errors."
  end

  it "successful edit with friendly forwarding" do
    visit edit_user_path(user)

    expect(page.current_url).to eq(login_url)
    fill_in "Email", with: user.email
    fill_in "Password", with: 'password'
    click_on "commit"

    expect(page.current_url).to eq(edit_user_url(user))
    name  = "Foo Bar"
    email = "foo@bar.com"
    fill_in "Name", with:  name
    fill_in "Email", with:  email
    click_on "commit"

    expect(page).to have_selector "div.alert-success", text: "Profile updated"
    expect(page.current_url).to eq(user_url(user))

    user.reload
    expect(user.name).to eq name
    expect(user.email).to eq email
  end
end
