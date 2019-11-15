class ContractsController < ApplicationController
  def api_request
  end

  def api_response
    request_type = params[:request_type]
    request_id = params[:request_id]
    request_data = JSON.parse(params[:request_data])

    case request_type
    when 'search'
      if !Contract.exists?(contract_id: request_data["contract_id"])
        render json: { massage: '【検索】idに一致する契約書が無い' }
      elsif Contract.find_by(contract_id: request_data["contract_id"]).pass != request_data["pass"]
        render json: { massage: '【検索】パスワードが違う' }
      else
        contract = Contract.find_by(contract_id: request_data["contract_id"])
        render json: { massage: '【検索】', id: contract.id, pass: contract.pass, user_id: contract.user_id, pdf_data: contract.pdf_data, contract_id: contract.contract_id, pdf_url: request.protocol + request.host_with_port + contract.pdf.url }
      end
    when 'sign'
      render json: { massage: '署名' }
    end
  end

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
    @contracts_templete = Contract.where(user_id: current_user.id)
  end

  def search

  end

  def show
    if !Contract.exists?(contract_id: seach_params[:contract_id])
      render 'search'
    elsif search_contract.pass != seach_params[:pass]
      render 'search'
    else
      @contract = search_contract
      @signed_contract = SignedContract.new
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

  def destroy
    @contract = find_contract
    @contract.destroy
    redirect_back(fallback_location: contracts_path)
  end

  private
  
  def upload_params
    params.require(:contract).permit(:pdf_file, :pass, :pdf).merge(user_id: current_user.id)
  end

  def seach_params
    params.permit(:contract_id, :pass)
  end

  def sign_params
    params[:sign]
  end

  def find_contract
    Contract.find(params[:id])
  end

  def search_contract
    Contract.find_by(contract_id: seach_params[:contract_id])
  end
end
