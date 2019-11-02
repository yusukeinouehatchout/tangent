class PictureUploader < Shrine
  plugin :data_uri
  plugin :determine_mime_type
end