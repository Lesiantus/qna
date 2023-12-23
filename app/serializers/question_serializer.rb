class QuestionSerializer < ActiveModel::Serializer
  include FileUrlHelper
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
end
