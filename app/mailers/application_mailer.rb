class ApplicationMailer < ActionMailer::Base
  default from: Rails.env == 'development' ?  ENV['FROM_ADDRESS'] : "noreply@example.com"
  layout 'mailer'
end
