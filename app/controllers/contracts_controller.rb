class ContractsController < ApplicationController
  def new
    @contract = Contract.new
  end

  def create
    @contract = Contract.new(upload_params)
    @contract.save
    redirect_to contracts_path
  end

  def index
    @contracts = Contract.where(user_id: current_user.id)
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

  def create_pdf
    sign = Sign.create!(image_data_uri: params[:sign])
    sign_url = "public/uploads/store/" + sign.image_data.match(/{\"id\":\"(.+)\",\"storage/)[1]
    
    respond_to do |format|
      format.pdf do
        test_pdf = RecordPdf.new(sign_url).render
        send_data test_pdf,
          filename:    'test.pdf',
          type:        'application/pdf',
          disposition: 'inline' # 画面に表示
      end
    end
    sign.destroy
  end

  private
  
  def upload_params
    params.require(:contract).permit(:pdf_file, :name, :pass).merge(user_id: current_user.id)
  end

  def seach_params
    params.permit(:id, :pass)
  end

  def find_contract
    Contract.find(seach_params[:id])
  end
end
