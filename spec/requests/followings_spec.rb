require 'rails_helper'

RSpec.describe "Followings", type: :request do
  let(:user) { users(:michael) }
  let(:other) { users(:archer) }

  before do
    log_in_as(user)
  end

  it "following page" do
    get following_user_path(user)
    expect(user.following.empty?).to be_falsey
    assert_match user.following.count.to_s, response.body
    user.following.each do |u|
      assert_select "a[href=?]", user_path(u)
    end
  end

  it "followers page" do
    get followers_user_path(user)
    expect(user.following.empty?).to be_falsey
    assert_match user.followers.count.to_s, response.body
    user.followers.each do |u|
      assert_select "a[href=?]", user_path(u)
    end
  end

  it "should follow a user the standard way" do
    expect{ post relationships_path, params: { followed_id: other.id }}.to change { user.following.count }.by(1)
  end

  it "should follow a user with Ajax" do
    expect{ post relationships_path, xhr: true, params: { followed_id: other.id }}.to change { user.following.count }.by(1)
  end

  it "should unfollow a user the standard way" do
    user.follow(other)
    relationship = user.active_relationships.find_by(followed_id: other.id)
    expect{delete relationship_path(relationship)}.to change { user.following.count }.by(-1)
  end

  it "should unfollow a user with Ajax" do
    user.follow(other)
    relationship = user.active_relationships.find_by(followed_id: other.id)
    expect{delete relationship_path(relationship), xhr: true}.to change { user.following.count }.by(-1)
  end

  it "feed on Home page" do
    get root_path
    user.feed.paginate(page: 1).each do |micropost|
      assert_match CGI.escapeHTML(micropost.content), response.body
    end
  end
end
