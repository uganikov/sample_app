require 'rails_helper'

RSpec.describe "Followings", type: :request do
  let(:user) { users(:michael) }
  let(:other) { users(:archer) }


  describe "without Ajax" do
    before do
      log_in_as(user)
    end

    it "following page" do
      expect(user.following).not_to be_empty
      visit following_user_path(user)
      expect(page).to have_selector "#following", text: user.following.count.to_s
      user.following.each do |u|
        expect(page).to have_selector "a[href='#{user_path(u)}']"
      end
    end

    it "followers page" do
      expect(user.followers).not_to be_empty
      visit followers_user_path(user)
      expect(page).to have_selector "#followers", text: user.followers.count.to_s
      user.followers.each do |u|
        expect(page).to have_selector "a[href='#{user_path(u)}']"
      end
    end

    it "should follow a user the standard way" do
      expect{
        visit user_path(other)
        click_on "Follow"
      }.to change { user.following.count }.by(1)
    end

    it "should unfollow a user the standard way" do
      user.follow(other)
      expect{
        visit user_path(other)
        click_on "Unfollow"
      }.to change { user.following.count }.by(-1)
    end

    it "feed on Home page" do
      visit root_path
      user.feed.paginate(page: 1).each do |micropost|
        expect(page).to have_selector ".content", text: micropost.content #capybara が unescapeHTML するようだ。
      end
    end
  end

  describe "with Ajax" do
    before do
      log_in_as(user, without_capybara: true)
    end

    it "should follow a user with Ajax" do
      expect{
        post relationships_path, xhr: true, params: { followed_id: other.id }
      }.to change { user.following.count }.by(1)
    end

    it "should unfollow a user with Ajax" do
      user.follow(other)
      relationship = user.active_relationships.find_by(followed_id: other.id)
      expect{
        delete relationship_path(relationship), xhr: true
      }.to change { user.following.count }.by(-1)
    end
  end

end
