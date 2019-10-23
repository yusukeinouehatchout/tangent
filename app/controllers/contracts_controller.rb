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

  private
  
  def upload_params
    params.require(:contract).permit(:pdf_file)
  end
end
