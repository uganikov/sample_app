require 'rails_helper'

RSpec.describe "UsersProfiles", type: :request do
  let(:user) { users(:michael) }

  it "profile display" do
    get user_path(user)
    assert_template 'users/show'
    assert_select 'title', full_title(user.name)
    assert_select 'h1', text: user.name
    assert_select 'h1>img.gravatar'
    assert_match user.microposts.count.to_s, response.body
    assert_select 'div.pagination', count: 1
    user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
    assert_select 'strong.stat', count: 2
  end
end
