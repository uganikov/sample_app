require 'rails_helper'

RSpec.describe "UserActivateds", type: :request do
  let(:user){ users(:michael)}
  let(:non_activated){ users(:devnull)}

  it "index of non activated user" do
    log_in_as(user)
    expect(non_activated).not_to be_activated
    visit users_path
    # fixture と paginate 単位から non_activated user が1ページ目に来ることを仮定している。
    # 超ダサいが、 users_index の統合テストも同じなのでとりあえず気にしないことにした。
    expect(page).not_to have_selector "a[href='#{user_path(non_activated)}']", text: non_activated.name
    visit user_path(non_activated)
    expect(page.current_url).to eq root_url
  end
end
