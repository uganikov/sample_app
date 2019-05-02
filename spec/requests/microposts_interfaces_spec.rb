require 'rails_helper'

RSpec.describe "MicropostsInterfaces", type: :request do
  let(:user) { users(:michael) }

  it "micropost interface" do
    log_in_as(user)
    visit root_path
    expect(page).to have_selector "div.pagination"
    expect(page).to have_selector "input[type=file]"
    # 無効な送信
    expect{
      click_on "Post"
    }.to_not change { Micropost.count }
    expect(page).to have_selector "div#error_explanation"
    # 有効な送信
    content = "This micropost really ties the room together"
    fill_in "micropost_content", with: content
    attach_file('spec/fixtures/rails.png')
    expect{ 
      click_on "Post"
    }.to change { Micropost.count }.by(1)
    expect(find('.content img')[:src]).to match /rails.png/
    expect(page.current_url).to eq(root_url)
    expect(page).to have_selector ".content", text: content
    # 投稿を削除する
    expect(page).to have_selector "a", text: 'delete'
    first_micropost = user.microposts.paginate(page: 1).first
    expect{ 
      click_on "delete", match: :first
    }.to change { Micropost.count }.by(-1)
    # 違うユーザーのプロフィールにアクセス (削除リンクがないことを確認)
    visit user_path(users(:archer))
    expect(page).not_to have_selector "a", text: 'delete'
  end

  it "micropost sidebar count" do
    log_in_as(user)
    visit root_path
    expect(page).to have_selector "span", text: "#{user.microposts.count} microposts" #class かなんかつけるべき
    # まだマイクロポストを投稿していないユーザー
    other_user = users(:malory)
    log_in_as(other_user)
    visit root_path
    expect(page).to have_selector "span", text: "0 microposts" #class かなんかつけるべき
    other_user.microposts.create!(content: "A micropost")
    visit root_path
    expect(page).to have_selector "span", text: "1 micropost" #class かなんかつけるべき
  end
end
