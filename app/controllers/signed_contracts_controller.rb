class SignedContractsController < ApplicationController
  def index
    @signed_contracts = SignedContract.where(user_id: current_user.id, templete_id: params[:templete_id])
  end

  def create
    binding.pry
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
