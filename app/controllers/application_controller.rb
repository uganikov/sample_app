class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

# これが private は気持ち悪い
protected

  # ユーザーのログインを確認する
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end
end
