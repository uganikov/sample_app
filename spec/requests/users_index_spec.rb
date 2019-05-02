require 'rails_helper'

RSpec.describe "UsersIndices", type: :request do
  let(:admin) { users(:michael) }
  let(:non_admin) { users(:archer) }

  it "index as admin including pagination and delete links" do
    log_in_as(admin)
    visit users_path
    expect(page).to have_selector 'div.pagination', count: 2
    first_page_of_users = User.where(activated: true).paginate(page: 1)
    first_page_of_users.each do |user|
      expect(page).to have_selector "a[href='#{user_path(user)}']", text: user.name
      unless user == admin
        expect(page).to have_selector "a[href='#{user_path(user)}']", text: 'delete'
      end
    end
    expect{
      click_on "delete", match: :first
    }.to change {User.count}.by(-1)
  end

  it "index as non-admin" do
    log_in_as(non_admin)
    visit users_path
    expect(page).to have_selector "a", text: 'delete', count: 0
  end
end
