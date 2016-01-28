class UsersController < ApplicationController

  before_action :authenticate_user!, except: [:confirmed]
  before_action :check_user, except: [:confirmed]

  def show
    @user = current_user
  end

  def photos
    @bus_stop_photos = BusStopPhoto.where(user_id: current_user.id)
                           .order("bus_stop_photos.created_at DESC")
                           .merge(BusStop.without_soft_destroyed)
                           .includes(:bus_stop).references(:bus_stop)
  end

  def confirmed
    if flash.blank?
      redirect_to root_path
    else
      flash.discard :notice
      flash.discard :error
    end
  end

  private

  def check_user
    if current_user.id != params[:id].to_i
      render 'common/access_denied'
      return
    end
  end
end
