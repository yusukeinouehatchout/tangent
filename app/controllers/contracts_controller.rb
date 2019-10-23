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
    if !Contract.exists?(seach_params[:id])
      render 'search'
    elsif find_contract.pass != seach_params[:pass]
      render 'search'
    else
      @contract = find_contract
      render 'show'
    end
  end

  private
  
  def upload_params
    params.require(:contract).permit(:pdf_file, :name, :pass)
  end

  def seach_params
    params.permit(:id, :pass)
  end

  def find_contract
    Contract.find(seach_params[:id])
  end
end
