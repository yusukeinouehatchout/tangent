class SignedContract < ApplicationRecord
  include PictureUploader::Attachment.new(:pdf)
  belongs_to :templete, class_name: "Contract"
end
