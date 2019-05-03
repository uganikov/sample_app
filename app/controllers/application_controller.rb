class ApplicationController < ActionController::Base
  before_action :set_locale
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

private
  def set_locale
    begin
      I18n.locale = params[:locale] || I18n.default_locale
      # RSpec はこれがないとデフォ値がつかないようだ。
      Rails.application.routes.default_url_options =  { locale: params[:locale] }
      # local サーバはこっちがないとデフォ値がつかないようだ。
      self.default_url_options =  { locale: params[:locale] }
      # 挙動がちがうのでこれで試験になっているとはいいがたい。
      # そして、ActionMailer にはこれがいる。
      ActionMailer::Base.default_url_options.merge!({ locale: params[:locale] })
    rescue I18n::InvalidLocale
      self.default_url_options[:locale] = nil
      Rails.application.routes.default_url_options[:locale] = nil
      ActionMailer::Base.default_url_options[:locale] = nil
    end
  end
end
