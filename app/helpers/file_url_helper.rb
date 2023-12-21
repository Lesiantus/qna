module FileUrlHelper
  def files_url
    object.files.map { |file| Rails.application.routes.url_helpers.rails_blob_url(file, host: 'localhost:3000') }
  end
end
