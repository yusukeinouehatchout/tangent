class Contract < ApplicationRecord
  include PictureUploader::Attachment.new(:pdf)
end
