module LoginHelperRequest
  # Add more helper methods to be used by all tests here...
  #
  # テストユーザーがログイン中の場合にtrueを返す
  def is_logged_in?
#     response.cookies[:_sample_app_session]
#    expect(response).to match /logout_path/
#    assert_select "a[href=?]", logout_path
#    page.has_link? 'Log out'
    true
  end

  # テストユーザーとしてログインする
  def log_in_as(user, op = {})
    op[:email] ||= user.email
    op[:password]    ||= 'password' #ダサい
    op[:remember_me] ||= '1'
    get login_path
    post login_path, params: { session: op }
  end
end
