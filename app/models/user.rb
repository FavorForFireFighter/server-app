class User < ActiveRecord::Base
  has_secure_password
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, email_format: {message: I18n.t('errors.attributes.email.invalid')},uniqueness: { case_sensitive: false }
  before_save { self.email = email.downcase }
  validates :password, length: {minimum: 8, if: :validate_password?}
  validates :password, format: {with: /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]{2,100}\z/i, message: I18n.t('errors.attributes.password.invalid'), if: :validate_password?}

  has_many :bus_stop_photos

  private
  def validate_password?
    if password_digest.present?
      password.present? || password_confirmation.present?
    else
      true
    end
  end
end