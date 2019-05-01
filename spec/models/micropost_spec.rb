require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let(:micropost) { users(:michael).microposts.build(content: "Lorem ipsum") }

  subject { micropost }
  it "should be valid" do
    is_expected.to be_valid
  end

  it "user id should be present" do
    micropost.user_id = nil
    is_expected.not_to be_valid
  end

  it "content should be present" do
    micropost.content = "   "
    is_expected.not_to be_valid
  end

  it "content should be at most 140 characters" do
    micropost.content = "a" * 141
    is_expected.not_to be_valid
  end

  it "order should be most recent first" do
    expect(microposts(:most_recent)).to eq Micropost.first
  end
end
