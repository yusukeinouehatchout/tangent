class Sign < ApplicationRecord
  include PictureUploader::Attachment.new(:image)
end
