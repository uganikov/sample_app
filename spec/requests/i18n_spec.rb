require 'rails_helper'

RSpec.describe "I18n", type: :request do
  it "works" do
    url = root_url
    expect(url).not_to  match %r{/(ja|en)/}
    visit url
    expect(page.current_url).to eq url

    visit "#{url}?locale=ja"
    click_on("Home")
    expect(page.current_url).to eq root_url(locale: :ja)
    expect(page.current_url).to match %r{/ja}

    visit "#{url}?locale=hoge"
    click_on("Home")
    expect(page.current_url).to eq url
  end
end
