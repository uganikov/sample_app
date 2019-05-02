require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) {  User.new(name: "Example User", email: "user@example.com",
			password: "foobar", password_confirmation: "foobar") }

  describe "validation" do
    subject{ user }
    it "should be valid" do
      is_expected.to be_valid
    end

    it "name should be present" do
      user.name = "     "
      is_expected.not_to be_valid
    end

    it "email should be present" do
      user.email = "     "
      is_expected.not_to be_valid
    end

    it "name should not be too long" do
      user.name = "a" * 51
      is_expected.not_to be_valid
    end

    it "email should not be too long" do
      user.email = "a" * 244 + "@example.com"
      is_expected.not_to be_valid
    end

    it "password should be present (nonblank)" do
      user.password = user.password_confirmation = " " * 6
      is_expected.not_to be_valid
    end

    it "password should have a minimum length" do
      user.password = user.password_confirmation = "a" * 5
      is_expected.not_to be_valid
    end

#    describe "email validation should accept valid addresses" do
      valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                           first.last@foo.jp alice+bob@baz.cn]
      valid_addresses.each do |valid_address|
        it "#{valid_address.inspect} should be valid" do
          user.email = valid_address
          is_expected.to be_valid
        end
      end
#    end
  end


  it "email addresses should be unique" do
    duplicate_user = user.dup
    duplicate_user.email = user.email.upcase
    user.save
    expect(duplicate_user).not_to be_valid
  end

  it "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    user.email = mixed_case_email
    user.save
    expect(user.reload.email).to eq mixed_case_email.downcase
  end


  it "authenticated? should return false for a user with nil digest" do
    expect(user).not_to be_authenticated(:remember,'')
  end

  it "associated microposts should be destroyed" do
    user.save
    user.microposts.create!(content: "Lorem ipsum")
    expect{user.destroy}.to change { User.count }.by(-1)
  end

  it "should follow and unfollow a user" do
    michael  = users(:michael)
    archer   = users(:archer)
    expect(michael).not_to be_following(archer)
    michael.follow(archer)
    expect(michael).to be_following(archer)
    expect(archer.followers.include?(michael)).to be_truthy
    michael.unfollow(archer)
    expect(michael).not_to be_following(archer)
  end

  it "feed should have the right posts" do
    michael = users(:michael)
    archer  = users(:archer)
    lana    = users(:lana)
    # フォローしているユーザーの投稿を確認
    lana.microposts.each do |post_following|
      expect(michael.feed).to be_include(post_following)
    end
    # 自分自身の投稿を確認
    michael.microposts.each do |post_self|
      expect(michael.feed).to be_include(post_self)
    end
    # フォローしていないユーザーの投稿を確認
    archer.microposts.each do |post_unfollowed|
      expect(michael.feed).not_to be_include(post_unfollowed)
    end
  end
end
