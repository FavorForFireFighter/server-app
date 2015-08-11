class Admin::ApplicationController < ApplicationController
  include SessionHelper
  layout 'admin'
  before_action :let_login
  before_action :check_admin

  private
  def check_admin
    unless is_admin?
      redirect_to root_path, alert:t('controller.common.not_admin')
    end
  end
end
