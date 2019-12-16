class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?  # deviseに追加したカラムを編集できるようにする
  before_action :set_selected_menu    # サイドバーで選択されているメニューを判断するための変数を定義

  protected

    def configure_permitted_parameters  # deviseに追加したカラムを編集できるようにする
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :belongs])
      devise_parameter_sanitizer.permit(:account_update, keys: [:name, :belongs])
    end

    def set_selected_menu   # サイドバーで選択されているメニューを判断するための変数を定義
      @selected_menu = {search_contracts: "",
                        index_contracts: "",
                        new_contracts: "",
                        account: "",
                        login: "",
                        sign_up: ""}
    end
end
