require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) {  User.new(name: "Example User", email: "user@example.com",
			password: "foobar", password_confirmation: "foobar") }

  it "should be valid" do
    expect(user.valid?).to be_truthy
  end

  it "name should be present" do
    user.name = "     "
    expect(user.valid?).to be_falsey
  end

  it "email should be present" do
    user.email = "     "
    expect(user.valid?).to be_falsey
  end

  it "name should not be too long" do
    user.name = "a" * 51
    expect(user.valid?).to be_falsey
  end

  it "email should not be too long" do
    user.email = "a" * 244 + "@example.com"
    expect(user.valid?).to be_falsey
  end

  it "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      user.email = valid_address
      assert user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  it "email addresses should be unique" do
    duplicate_user = user.dup
    duplicate_user.email = user.email.upcase
    user.save
    expect(duplicate_user.valid?).to be_falsey
  end

  it "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    user.email = mixed_case_email
    user.save
    assert_equal mixed_case_email.downcase, user.reload.email
  end

  it "password should be present (nonblank)" do
    user.password = user.password_confirmation = " " * 6
    expect(user.valid?).to be_falsey
  end

  it "password should have a minimum length" do
    user.password = user.password_confirmation = "a" * 5
    expect(user.valid?).to be_falsey
  end

  it "authenticated? should return false for a user with nil digest" do
    expect(user.authenticated?(:remember,'')).to be_falsey
  end

  it "associated microposts should be destroyed" do
    user.save
    user.microposts.create!(content: "Lorem ipsum")
    expect{user.destroy}.to change { User.count }.by(-1)
  end

  it "should follow and unfollow a user" do
    michael  = users(:michael)
    archer   = users(:archer)
    expect(michael.following?(archer)).to be_falsey
    michael.follow(archer)
    expect(michael.following?(archer)).to be_truthy
    expect(archer.followers.include?(michael)).to be_truthy
    michael.unfollow(archer)
    expect(michael.following?(archer)).to be_falsey
  end

  it "feed should have the right posts" do
    michael = users(:michael)
    archer  = users(:archer)
    lana    = users(:lana)
    # フォローしているユーザーの投稿を確認
    lana.microposts.each do |post_following|
      expect(michael.feed.include?(post_following)).to be_truthy
    end
    # 自分自身の投稿を確認
    michael.microposts.each do |post_self|
      expect(michael.feed.include?(post_self)).to be_truthy
    end
    # フォローしていないユーザーの投稿を確認
    archer.microposts.each do |post_unfollowed|
      expect(michael.feed.include?(post_unfollowed)).to be_falsey
    end
  end
end
