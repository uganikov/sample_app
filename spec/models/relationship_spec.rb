require 'rails_helper'

RSpec.describe Relationship, type: :model do

  let(:relationship) { Relationship.new(follower_id: users(:michael).id,
                                     followed_id: users(:archer).id)}

  subject {relationship}
  it "should be valid" do
    is_expected.to be_valid
  end

  it "should require a follower_id" do
    relationship.follower_id = nil
    is_expected.to_not be_valid
  end

  it "should require a followed_id" do
    relationship.followed_id = nil
    is_expected.to_not be_valid
  end
end
