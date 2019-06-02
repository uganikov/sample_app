require 'rails_helper'

RSpec.describe "I18n", type: :request do
  let(:url) { root_url }
  let(:user) { users(:michael) }

  it "is English in default" do
    log_in_as(user)
    expect(url).not_to match %r{/(ja|en)/}
    visit url
    expect(page.current_url).to eq url
    expect(page).not_to have_content "分"
  end

  it "is Japanese when instruct by query parameter or url" do
    log_in_as(user)
    visit "#{url}?locale=ja"
    click_on("ホーム")
    expect(page.current_url).to eq root_url(locale: :ja)
    expect(page).to have_content "分"
  end

  it "is default behaovr when instruct wrong locale" do
    log_in_as(user)
    visit "#{url}?locale=hoge"
    click_on("Home")
    expect(page.current_url).to eq url
    expect(page).not_to have_content "分"
  end

  it "is Japanese when instruct by Accept-Language" do
    log_in_as(user)
    page.driver.header('Accept-Language', "ja-JP")
    visit "#{url}"
    click_on("ホーム")
    expect(page.current_url).to eq root_url
    expect(page).to have_content "分"
  end

end
