module LoginHelperRequest
  # Add more helper methods to be used by all tests here...
  #
  # テストユーザーがログイン中の場合にtrueを返す
  def is_logged_in?
    page.has_link? 'Log out'
  end

  # テストユーザーとしてログインする
  def log_in_as(user, op = {})
    op[:email] ||= user.email
    op[:password]    ||= 'password' #ダサい
    op[:without_capybara] ||= false

    if(op[:without_capybara])
      op[:remember_me] ||= '1'
      op[:without_capybara] = nil
      get login_path
      post login_path, params: { session: op }
    else
      op[:remember_me] ||= false
      visit login_path
      fill_in "Email", with: op[:email]
      fill_in "Password", with: op[:password]
      check "session[remember_me]" if op[:remember_me]
      click_on "commit"
    end
  end

  def steal_token(what_token)
    token = Nokogiri::HTML(ActionMailer::Base.deliveries.first.body.parts[1].body.raw_source)
                    .css("a").first[:href]
                    .gsub(%r{^.*#{what_token}/}, '')
                    .gsub(%r{/.*$}, '')
    token
  end
end
