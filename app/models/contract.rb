class Contract < ApplicationRecord
  include PictureUploader::Attachment.new(:pdf)
  has_many :signed_contracts, class_name: "SignedContract", foreign_key: "templete_id", dependent: :destroy
end
