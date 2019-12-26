class ContractsController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :authenticate_user!, only: [:new, :create, :index]

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
      sign_image = request_data["sign_image"]
      templete_id = request_data["templete_id"]
      user_id = request_data["user_id"]
      name = request_data["name"]

      uuid = SecureRandom.uuid

      sign = Sign.create!(image_data_uri: sign_image)
      sign_url = "public/" + sign.image.url
      contract_url = "public/" + Contract.find(templete_id).pdf.url

      respond_to do |format|
        format.html do
          sign_pdf = RecordPdf.new(sign_url).render
  
          @combine_pdf = CombinePDF.new
          @combine_pdf << CombinePDF.load(contract_url)
          @combine_pdf << CombinePDF.parse(sign_pdf)
          @combine_pdf.save "public/uploads/cache/#{uuid}combined.pdf"
        end
      end
      sign.destroy

      p = Rack::Test::UploadedFile.new("public/uploads/cache/#{uuid}combined.pdf", "application/pdf")
      @signed_contract = SignedContract.new(templete_id: templete_id, user_id: user_id, pdf: p, name: name)
      @signed_contract.save

      render json: { massage: '提出成功' }
    end
  end

  def new
    @selected_menu[:new_contracts] = "selected-menu"
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
    @selected_menu[:index_contracts] = "selected-menu"
    @contracts_templete = Contract.where(user_id: current_user.id)
  end

  def search
    @selected_menu[:search_contracts] = "selected-menu"
  end

  def show
    @selected_menu[:search_contracts] = "selected-menu"
    if !Contract.exists?(contract_id: seach_params[:contract_id])
      @error_msg = "※入力された契約書IDは存在しません。"
      render 'search'
    elsif search_contract.pass != seach_params[:pass]
      @error_msg = "※パスワードが間違っています。"
      render 'search'
    else
      @contract = search_contract
      @signed_contract = SignedContract.new
      render 'show'
    end
  end

  def combine   # 契約書と署名のpdfをマージして、ユーザーにダウンロードさせる→ダウンロードさせた契約書をアップロードしてもらう
    sign = Sign.create!(image_data_uri: sign_params)      # 署名の画像データ
    sign_url = "public/" + sign.image.url                 # 署名の画像データのURL
    contract_url = "public/" + find_contract.pdf.url      # 契約書のURL

    uuid = SecureRandom.uuid    # 提出する署名済契約書を識別するための一意の文字列を生成

    # 契約書と署名を結合して、cacheに一時保存
    respond_to do |format|
      format.pdf do
        sign_pdf = RecordPdf.new(sign_url).render

        @combine_pdf = CombinePDF.new
        @combine_pdf << CombinePDF.load(contract_url)
        @combine_pdf << CombinePDF.parse(sign_pdf)
        @combine_pdf.save "public/uploads/cache/#{uuid}combined.pdf"
      end
    end
    sign.destroy  # 署名の画像データは不要になるため削除

    # cacheに一時保存した署名済契約書をアップロードして、DBに保存
    signed_pdf = Rack::Test::UploadedFile.new("public/uploads/cache/#{uuid}combined.pdf", "application/pdf")
    @signed_contract = new_signed_contract(signed_pdf)
    @signed_contract.save

    redirect_to root_path
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

  def signed_name_params
    params.permit(:name)
  end

  def new_signed_contract(signed_pdf)
    SignedContract.new(templete_id: find_contract.id, user_id: find_contract.user_id, pdf: signed_pdf, name: signed_name_params[:name])
  end
end
