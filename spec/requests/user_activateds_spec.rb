require 'rails_helper'

RSpec.describe "UserActivateds", type: :request do
  let(:user){ users(:michael)}
  let(:non_activated){ users(:devnull)}

  it "index of non activated user" do
    log_in_as(user)
    expect(non_activated.activated?).to be_falsey
    get users_path
    # fixture と paginate 単位から non_activated user が1ページ目に来ることを仮定している。
    # 超ダサいが、 users_index の統合テストも同じなのでとりあえず気にしないことにした。
    assert_select 'a[href=?]', user_path(non_activated), text: non_activated.name, count: 0
    get user_path(non_activated)
    assert_redirected_to root_url
  end
end
