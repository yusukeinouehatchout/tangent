class Contract < ApplicationRecord
  include PictureUploader::Attachment.new(:pdf)
  has_many :signed_contracts, dependent: :destroy
end
