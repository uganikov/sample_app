require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let(:user) { users(:michael) }
  let(:micropost) { user.microposts.build(content: "Lorem ipsum") }

  it "should be valid" do
    expect(micropost.valid?).to be_truthy
  end

  it "user id should be present" do
    micropost.user_id = nil
    expect(micropost.valid?).to be_falsey
  end

  it "content should be present" do
    micropost.content = "   "
    expect(micropost.valid?).to be_falsey
  end

  it "content should be at most 140 characters" do
    micropost.content = "a" * 141
    expect(micropost.valid?).to be_falsey
  end

  it "order should be most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end
end
