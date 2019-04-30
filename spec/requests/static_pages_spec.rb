require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  before(:all) do
    @base_title = "Ruby on Rails Tutorial Sample App"
  end

  it "get root" do
    get root_url
    expect(response).to have_http_status(200)
  end

  it "get home" do
    get root_path
    expect(response).to have_http_status(200)
    assert_select "title", "#{@base_title}"
  end

  it "get help" do
    get help_path
    expect(response).to have_http_status(200)
    assert_select "title", "Help | #{@base_title}"
  end

  it "get about" do
    get about_path
    expect(response).to have_http_status(200)
    assert_select "title", "About | #{@base_title}"
  end

  it "get contact" do
    get contact_path
    expect(response).to have_http_status(200)
    assert_select "title", "Contact | #{@base_title}"
  end
end
