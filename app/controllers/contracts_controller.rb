class ContractsController < ApplicationController
  def new
    @contract = Contract.new
  end

  def create
    # binding.pry
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
    # sign_url = "public/uploads/store/" + sign.image_data.match(/{\"id\":\"(.+)\",\"storage/)[1]
    sign_url = "public/" + sign.image.url
    contract_url = "public/" + find_contract.pdf.url

    
    respond_to do |format|
      format.pdf do
        sign_pdf = RecordPdf.new(sign_url).render

        # active storageからpdfのURLを取得しようとしたが、どれも上手く使えなかった
        # contract_url = polymorphic_url(find_contract.pdf_file)
        # contract_url = open(find_contract.pdf_url).path
        # contract_url = StringIO.open(find_contract.pdf_file.download)
        # binding.pry
        
        # contract_pdf = RecordPdf.new(contract_url).render
        # contract_pdf = RecordPdf.new("contract.pdf", template: contract_url).render
        # contract_pdf = PDF::Reader.new(contract_url)
        # binding.pry

        combine_pdf = CombinePDF.new
        # combine_pdf << CombinePDF.parse(contract_pdf)
        combine_pdf << CombinePDF.load(contract_url)
        combine_pdf << CombinePDF.parse(sign_pdf)
        combine_pdf.save "combined.pdf"

        send_data combine_pdf.to_pdf,
          filename:    'combined.pdf',
          type:        'application/pdf',
          disposition: 'inline' # 画面に表示
      end
    end

    # 書名PDFを表示する処理を退避
    # respond_to do |format|
    #   format.pdf do
    #     sign_pdf = RecordPdf.new(sign_url).render
    #     send_data sign_pdf,
    #       filename:    'test.pdf',
    #       type:        'application/pdf',
    #       disposition: 'inline' # 画面に表示
    #   end
    # end
    sign.destroy
  end

  private
  
  def upload_params
    params.require(:contract).permit(:pdf_file, :name, :pass, :pdf).merge(user_id: current_user.id)
  end

  def seach_params
    params.permit(:id, :pass)
  end

  def find_contract
    Contract.find(seach_params[:id])
  end
end
