class ApplicationMailer < ActionMailer::Base
  default from: Rails.env == 'production' ?  ENV['FROM_ADDRESS'] : "noreply@example.com"
  layout 'mailer'
end
