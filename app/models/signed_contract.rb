class SignedContract < ApplicationRecord
  include PictureUploader::Attachment.new(:pdf)
end
