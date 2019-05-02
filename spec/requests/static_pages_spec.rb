require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  before(:all) do
    @base_title = "Ruby on Rails Tutorial Sample App"
  end

  it "get root" do
    visit root_url
    expect(page).to have_http_status(:success)
  end

  it "get home" do
    visit root_path
    expect(page).to have_http_status(:success)
    expect(page).to have_title "#{@base_title}"
  end

  it "get help" do
    visit help_path
    expect(page).to have_http_status(:success)
    expect(page).to have_title "Help | #{@base_title}"
  end

  it "get about" do
    visit about_path
    expect(page).to have_http_status(:success)
    expect(page).to have_title "About | #{@base_title}"
  end

  it "get contact" do
    visit contact_path
    expect(page).to have_http_status(:success)
    expect(page).to have_title "Contact | #{@base_title}"
  end
end
