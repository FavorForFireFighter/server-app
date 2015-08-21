class Admin::ApplicationController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :check_admin

  private
  def check_admin
    unless current_user.admin_flag
      redirect_to root_path, alert:t('controller.common.not_admin')
    end
  end
end
