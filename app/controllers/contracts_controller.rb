class ContractsController < ApplicationController
  def new
    @contract = Contract.new
  end

  def create
    @contract = Contract.new(upload_params)
    @contract.save
  end

  def index
    @contracts = Contract.all
  end

  def search

  end

  def show
    @contract = Contract.find(seach_params[:id])
  end

  private
  
  def upload_params
    params.require(:contract).permit(:pdf_file, :name, :pass)
  end

  def seach_params
    params.permit(:id)
  end
end
