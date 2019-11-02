class RecordPdf < Prawn::Document
  def initialize(sign)
    super()

    image sign
  end
end