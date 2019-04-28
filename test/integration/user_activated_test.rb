require 'test_helper'

class UserActivatedTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @non_activated = users(:devnull)
  end

  test "index of non activated user" do
    log_in_as(@user)
    assert_not @non_activated.activated?
    get users_path
    # fixture と paginate 単位から non_activated user が1ページ目に来ることを仮定している。
    # 超ダサいが、 users_index の統合テストも同じなのでとりあえず気にしないことにした。
    assert_select 'a[href=?]', user_path(@non_activated), text: @non_activated.name, count: 0
    get user_path(@non_activated)
    assert_redirected_to root_url
  end
end
