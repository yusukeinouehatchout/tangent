class UsersController < ApplicationController
  def show
    @selected_menu[:account] = "selected-menu"
    @user = current_user
  end
end
