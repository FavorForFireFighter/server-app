class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable, :rememberable,
  devise :database_authenticatable, :registerable, :trackable, :validatable, :confirmable, :recoverable
=begin
  has_secure_password
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, email_format: {message: I18n.t('errors.attributes.email.invalid')},uniqueness: { case_sensitive: false }
  before_save { self.email = email.downcase }
  validates :password, length: {minimum: 8, if: :validate_password?}
  validates :password, format: {with: /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]{2,100}\z/i, message: I18n.t('errors.attributes.password.invalid'), if: :validate_password?}
=end
  validates :username, presence: true, uniqueness: true
  validates :password, format: {with: /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]{2,100}\z/i, message: I18n.t('errors.attributes.password.invalid'), if: :validate_password?}

  has_many :bus_stop_photos

  scope :not_deleted, -> () {
    where(deleted_at: nil)
  }

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if username = conditions.delete(:username)
      where(conditions.to_hash).where(["username = :value", {:value => username}]).first
    else
      where(conditions.to_hash).first
    end
  end

  # instead of deleting, indicate the user requested a delete & timestamp it
  def soft_delete
    update_attribute(:deleted_at, Time.current)
  end

  # ensure user account is active
  def active_for_authentication?
    super && !deleted_at
  end

  # provide a custom message for a deleted account
  def inactive_message
    !deleted_at ? super : :deleted_account
  end

  # override Devise::Models::Confirmable#send_on_create_confirmation_instructions
  def send_on_create_confirmation_instructions
    generate_confirmation_token! unless @raw_confirmation_token
    send_devise_notification(:confirmation_on_create_instructions, @raw_confirmation_token, {})
  end

  private
  def validate_password?
    if encrypted_password.present?
      password.present? || password_confirmation.present?
    else
      true
    end
  end
end