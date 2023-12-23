class AnswerSerializer < ActiveModel::Serializer
  include FileUrlHelper
  attributes :id,
             :body,
             :user_id,
             :question_id,
             :created_at,
             :updated_at,
             :files_url
  has_many :links
  has_many :comments
end
