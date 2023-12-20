class AnswerSerializer < ActiveModel::Serializer
  attributes :id,
             :body,
             :user_id,
             :question_id,
             :created_at,
             :updated_at,
             :files_url
  has_many :links
  has_many :comments

  def files_url
    object.files.map { |file| Rails.application.routes.url_helpers.rails_blob_url(file, host: 'localhost:3000') }
  end
end
