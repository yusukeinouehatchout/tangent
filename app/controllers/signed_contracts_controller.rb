class SignedContractsController < ApplicationController
  def index
    @selected_menu[:index_contracts] = "selected-menu"
    @signed_contracts = SignedContract.where(user_id: current_user.id)
  end

  def every_templete_index
    @selected_menu[:index_contracts] = "selected-menu"
    @signed_contracts = SignedContract.where(user_id: current_user.id, templete_id: params[:templete_id])
  end

  def create
    @signed_contract = SignedContract.new(signed_contract_params)
    @signed_contract.save
    redirect_to root_path
  end

  def destroy
    @signed_contract = find_signed_contract
    @signed_contract.destroy
    redirect_back(fallback_location: signed_contracts_path)
  end

  private

  def signed_contract_params
    params.require(:signed_contract).permit(:templete_id, :user_id, :pdf, :name)
  end

  def find_signed_contract
    SignedContract.find(params[:id])
  end
end
