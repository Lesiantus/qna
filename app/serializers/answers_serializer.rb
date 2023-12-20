class AnswersSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :body, :question_id, :created_at, :updated_at
end
