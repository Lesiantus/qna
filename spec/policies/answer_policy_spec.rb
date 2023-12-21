require 'rails_helper'

RSpec.describe AnswerPolicy, type: :policy do
  let!(:user) { create(:user, admin: true) }
  let!(:not_admin) { create(:user) }

  subject { described_class }

  permissions :update? do
    it 'grants access if user is admin' do
      expect(subject).to permit(user, create(:answer, user: user))
    end

    it 'grants access if user is author' do
      expect(subject).to permit(user, create(:answer, user: not_admin))
    end

    it 'denies access if user is not author' do
      expect(subject).not_to permit(User.new, create(:answer, user: not_admin))
    end
  end
end
