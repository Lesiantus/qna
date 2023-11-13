require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }
  let!(:not_author) { create(:user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      before { login(user) }
      it 'saves a new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :json }.to change(Answer, :count).by(1)
      end
      it 'assigns the answer to the question' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :json
        expect(assigns(:answer).question).to eq question
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js }.to_not change(question.answers, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'user is an author' do
      before { login(user) }

      it 'delete the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end
    end

    context 'user is not an author' do
      let(:not_author) { create(:user) }
      before { login(not_author) }

      it 'delete answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end

      it 'redirect to index view' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(answer.question)
      end
    end
  end

  describe 'PATCH #update' do
    describe 'Author updates answer' do
      before { login(user) }
      context 'with valid attributes' do
        before { patch :update, params: { id: answer, answer: { body: 'new body' }, question_id: question }, format: :js }
        it 'changes answer attributes' do
          answer.reload
          expect(answer.body).to eq 'new body'
        end

        it 'renders update view' do
          expect(response).to redirect_to question_path(question)
        end
      end

      context 'with invalid attributes' do
        it 'does not change answer attributes' do
          expect do
            patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), question_id: question }, format: :js
          end.to_not change(answer, :body)
        end

        it 'renders show view' do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), question_id: question }, format: :js
          expect(response).to render_template 'answers/update'
        end
      end
    end
    describe 'Not author tries to update answer' do
      before { login(not_author) }
      before { patch :update, params: { id: answer, answer: { body: "New body" }, question_id: question }, format: :js }
      it 'changes answer attributes' do
        answer.reload
        expect(answer.body).to_not eq 'New body'
      end

      it 'renders :update back to question' do
        expect(response).to redirect_to answer.question
      end
    end
  end
  describe 'POST #best' do
    context 'Authenticated author' do
      before { login(user) }
      before { post :best, params: { id: answer }, format: :js }

      it ' selects answer as best' do
        answer.reload
        expect(answer).to be_best
      end

      it ' renders best template' do
        expect(response).to render_template :best
      end
    end

    context 'Authenticated user as not an author' do
      before { login(not_author) }
      before { post :best, params: { id: answer }, format: :js }

      it 'can not select answer as the best' do
        answer.reload
        expect(answer).to_not be_best
      end

      it 'render best template' do
        expect(response).to render_template :best
      end
    end

    context 'Not authenticated user' do
      before { post :best, params: { id: answer }, format: :js }
      it 'can not select answer as the best' do
        answer.reload
        expect(answer).to_not be_best
      end
    end
  end
end
