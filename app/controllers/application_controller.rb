class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?  # deviseに追加したカラムを編集できるようにする

  protected

    def configure_permitted_parameters  # deviseに追加したカラムを編集できるようにする
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :belongs])
      devise_parameter_sanitizer.permit(:account_update, keys: [:name, :belongs])
    end
end
