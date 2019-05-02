require 'rails_helper'

RSpec.describe "UsersProfiles", type: :request do
  let(:user) { users(:michael) }

  it "profile display" do
    visit user_path(user)
    expect(page).to have_title full_title(user.name)
    expect(page).to have_selector 'h1', text: user.name
    expect(page).to have_selector 'h1>img.gravatar'
    expect(page).to have_content user.microposts.count.to_s
    expect(page).to have_selector 'div.pagination', count: 1
    user.microposts.paginate(page: 1).each do |micropost|
      expect(page).to have_content micropost.content
    end
    expect(page).to have_selector 'strong.stat', count: 2
  end
end
