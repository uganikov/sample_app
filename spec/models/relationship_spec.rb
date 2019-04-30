require 'rails_helper'

RSpec.describe Relationship, type: :model do

  let(:relationship) { Relationship.new(follower_id: users(:michael).id,
                                     followed_id: users(:archer).id)}

  it "should be valid" do
    expect(relationship.valid?).to be_truthy
  end

  it "should require a follower_id" do
    relationship.follower_id = nil
    expect(relationship.valid?).to be_falsey
  end

  it "should require a followed_id" do
    relationship.followed_id = nil
    expect(relationship.valid?).to be_falsey
  end
end
