class Contract < ApplicationRecord
  # has_one_attached :pdf_file
  include PictureUploader::Attachment.new(:pdf)
end
