class ContractsController < ApplicationController
  def new
    @contract = Contract.new
  end

  def create
    if upload_params[:pdf].present? && upload_params[:pass].present?
      @contract = Contract.new(upload_params)
      @contract.save
  
      contract_id = @contract.id
      contract_id = contract_id.to_s
      for i in 1..2
        contract_id += ('A'..'Z').to_a[rand(26)]
      end
      @contract.update(contract_id: contract_id)
  
      redirect_to contracts_path
    else
      render 'new'
    end
  end

  def index
    @contracts_templete = Contract.where(user_id: current_user.id, signed: false)
    @contracts_signed = Contract.where(user_id: current_user.id, signed: true)
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
      @signed_contract = Contract.new
      render 'show'
    end
  end

  def combine   # 契約書と署名のpdfをマージして、ユーザーにダウンロードさせる→ダウンロードさせた契約書をアップロードしてもらう
    sign = Sign.create!(image_data_uri: sign_params)
    sign_url = "public/" + sign.image.url
    contract_url = "public/" + find_contract.pdf.url

    respond_to do |format|
      format.pdf do
        sign_pdf = RecordPdf.new(sign_url).render

        @combine_pdf = CombinePDF.new
        @combine_pdf << CombinePDF.load(contract_url)
        @combine_pdf << CombinePDF.parse(sign_pdf)
        @combine_pdf.save "combined.pdf"
        send_data @combine_pdf.to_pdf,
          filename:    'combined.pdf',
          type:        'application/pdf'
      end
    end
    sign.destroy
  end

  def create_signed_pdf
    @contract = Contract.new(signed_pdf_params)
    @contract.save
    redirect_to root_path
  end

  private
  
  def upload_params
    params.require(:contract).permit(:pdf_file, :name, :pass, :pdf).merge(user_id: current_user.id)
  end

  def seach_params
    params.permit(:id, :pass)
  end

  def sign_params
    params[:sign]
  end

  def signed_pdf_params
    params.require(:contract).permit(:pdf_file, :name, :pass, :pdf, :user_id, :signed)
  end

  def find_contract
    Contract.find(seach_params[:id])
  end
end
