require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  let(:user) { users(:michael) }
  let(:other_user) { users(:archer) }

  describe "when not logged in" do 
    it "should get new" do
      get :new
      expect(response).to have_http_status(:success)
    end

    describe "should redirect to login_url" do
      after do
        is_expected.to redirect_to login_url
        expect(flash).not_to be_empty
      end

      it "is edit" do
        get :edit, params: { id: user }
      end

      it "is update" do
        patch :update, params: {id: user, user: { name: user.name,
                                                  email: user.email } }
      end

      it "is index" do
        get :index
      end

      it "is destroy" do
        expect{delete :destroy, params: { id: user }}.to_not change { User.count }
      end

      it "is following" do
        get :following, params: { id: user }
      end

      it "is followers" do
        get :followers, params: { id: user }
      end
    end
  end

  describe "when logged in as wrong user" do 
    before do
      log_in_as(other_user)
    end

    after do
      expect(flash.empty?).to be_truthy
      is_expected.to redirect_to root_url
    end

    it "should redirect edit" do
      get :edit, params: { id: user }
    end

    it "should redirect update" do
      patch :update, params: {id: user, user: { name: user.name,
                                              email: user.email } }
    end
  end

  describe "when logged in as non admin user" do 
    before do
      log_in_as(other_user)
    end

    it "should not allow the admin attribute to be edited via the web" do
      expect(other_user).not_to be_admin
      patch :update, params: {id: other_user,  
                                      user: { admin: 1 } }
      expect(other_user.reload).not_to be_admin
    end

    it "should redirect destroy" do
      expect{delete :destroy, params: { id: user }}.to_not change { User.count }
      is_expected.to redirect_to root_url
    end
  end
end
