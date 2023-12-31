class Answer < ApplicationRecord
  include Votable
  include Commentable
  belongs_to :question
  belongs_to :user

  has_many_attached :files
  has_many :links, dependent: :destroy, as: :linkable

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  default_scope -> { order('best DESC, created_at') }
  scope :best, -> { where(best: true) }

  def best!
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
      question.award&.update!(user: user)
    end
  end

  def files_info
    files.map { |file| { name: file.filename.to_s, id: file.id } }
  end
end
