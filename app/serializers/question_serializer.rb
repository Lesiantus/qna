class QuestionSerializer < ActiveModel::Serializer
  attributes :id,
             :title,
             :body,
             :created_at,
             :updated_at,
             :short_title,
             :files_url
  has_many :answers
  belongs_to :user
  has_many :links
  has_many :comments

  def short_title
    object.title.truncate(7)
  end

  def files_url
    object.files.map { |file| Rails.application.routes.url_helpers.rails_blob_url(file, host: 'localhost:3000') }
  end
end
