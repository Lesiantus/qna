require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should accept_nested_attributes_for :links }
  it { should have_db_index :user_id }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it 'have many attached file' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
  describe 'reputation' do
    let(:question) { build(:question) }
    it 'calls ReputationJob' do
      expect(ReputationJob).to receive(:perform_later).with(question)
      question.save!
    end
  end
end
