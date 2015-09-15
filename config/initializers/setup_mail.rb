configs = YAML::load(File.open("#{Rails.root.to_s}/config/email.yml"))
unless configs[Rails.env].nil?
  email_settings = configs[Rails.env]
  ActionMailer::Base.delivery_method = email_settings[:delivery_method] unless email_settings[:delivery_method].nil?
  ActionMailer::Base.smtp_settings = email_settings[:smtp_settings] unless email_settings[:smtp_settings].nil?
  ActionMailer::Base.sendmail_settings = email_settings[:sendmail_settings] unless email_settings[:sendmail_settings].nil?
  ActionMailer::Base.default_options = email_settings[:default_options] unless email_settings[:default_options].nil?
end
