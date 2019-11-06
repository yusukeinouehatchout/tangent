class RecordPdf < Prawn::Document
  def initialize(sign_url)
    super()

    image sign_url
    # sign_url.render_body
  end

  # def initialize(filename, template: "path")
  #   # binding.pry

  #   super()
  # end

  # def add_image(sign_url)
  #   image sign_url
  # end
end