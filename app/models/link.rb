class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true
  validates :name, presence: true
  validates :url, presence: true, http_url: true

  GIST_REGEXP = /^https:\/\/gist\.github\.com\/\w+\/\w+/i



  def gist?
    url.match?(GIST_REGEXP)
  end

  def gist_body
    url.split('/').last
  end
end
