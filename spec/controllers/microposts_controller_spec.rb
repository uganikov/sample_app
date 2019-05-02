require 'rails_helper'

RSpec.describe MicropostsController, type: :controller do
  let(:micropost) { microposts(:orange) }

  it "should redirect create when not logged in" do
    expect{ post :create, params: { micropost: { content: "Lorem ipsum" } } }.to_not change { Micropost.count }
    is_expected.to redirect_to login_url
  end

  it "should redirect destroy when not logged in" do
    expect{ delete :destroy, params: { id: micropost } }.to_not change { Micropost.count }
    is_expected.to redirect_to login_url
  end

  it "should redirect destroy for wrong micropost" do
    log_in_as(users(:michael))
    expect{ delete :destroy, params: { id: microposts(:ants) } }.to_not change { Micropost.count }
    is_expected.to redirect_to root_url
  end
end
