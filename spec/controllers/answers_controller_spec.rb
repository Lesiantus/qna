require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      before { login(user) }
      it 'saves a new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }.to change(Answer, :count).by(1)
      end
      it 'redirects to question_answers_path' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to question_answers_path(question)
      end
      it 'assigns the answer to the question' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(assigns(:answer).question).to eq question
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question } }.to_not change(question.answers, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'user is an author' do
      before { login(user) }

      let!(:answer) { create(:answer, user: user, question: question) }


      it 'delete the answer' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirect to index' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(answer.question)
      end
    end

    context 'user is not an author' do
      let(:not_author) { create(:user) }
      before { login(not_author) }
      let!(:answer) { create(:answer, user: user, question: question) }


      it 'delete answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end

      it 'redirect to index view' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(answer.question)
      end
    end
  end
end
