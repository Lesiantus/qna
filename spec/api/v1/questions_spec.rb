require 'rails_helper'

describe 'Qestions API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => "application/json" } }
  let(:access_token) { create(:access_token) }
  it_behaves_like 'API authorizable' do
    let(:api_path) { '/api/v1/questions' }
    let(:method) { :get }
  end
  describe 'GET /api/v1/questions' do
    context 'authorized' do
      let!(:user) { create(:user) }
      let!(:questions) { create_list(:question, 2, user: user) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question, user: user) }
      before { get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end
      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end
      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end
      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end
      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }
        it 'returns list of questions' do
          expect(question_response['answers'].size).to eq 3
        end
        it 'returns all public fields' do
          %w[id user_id body created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let!(:question) { create(:question, files: [Rack::Test::UploadedFile.new("#{Rails.root}/spec/test_picture/pic.png")])}
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:question_response) { json['question'] }

    before { get api_path, params: { access_token: access_token.token }, headers: headers }

    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    it_should_behave_like 'API status success'

    it 'returns all public fiels' do
      %w[id title body created_at updated_at].each do |attr|
        expect(question_response[attr]).to eq question.send(attr).as_json
      end
    end
    it 'returns files url' do
      expect(question_response['files_url'].first).to match 'pic.png'
    end
  end

  describe 'POST api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    let(:headers) { { "ACCEPT" => "application/json" } }

    it_behaves_like 'API authorizable' do
      let(:method) { :post }
    end

    describe 'create question' do
      context 'with valid attributed' do
        before { post api_path, params: { question: attributes_for(:question),
                                          access_token: access_token.token },
                                          headers: headers }

        it_should_behave_like 'API status success'

        it 'saves new question into DB' do
          expect(Question.count).to eq 1
        end

        it 'returns fields of new question' do
          %w[id title body created_at updated_at].each do |attr|
            expect(json['question'].has_key?(attr)).to be_truthy
          end
        end
      end

      context 'with invalid attributes' do
        before { post api_path, params: { question: attributes_for(:question, :invalid),
                                          access_token: access_token.token },
                                          headers: headers }

        it 'returns unprocessable status' do
          expect(response).to be_unprocessable
        end
      end
    end
  end
  describe 'PATCH /api/v1/questions/:id' do
    let!(:author) { create(:user)}
    let!(:question) { create(:question, user: author) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:headers) { { "ACCEPT" => 'application/json' } }

    it_behaves_like 'API authorizable' do
      let(:method) { :put }
    end

    describe 'author' do
      let(:author_access_token) { create(:access_token, resource_owner_id: question.user.id) }

      context 'update with valid attributes' do
        before { patch api_path, params: { access_token: author_access_token.token,
                                           question: { body: 'New body' } },
                                           headers: headers  }

        it_should_behave_like 'API status success'

        it 'returns modified question fields ' do
          %w[id title body created_at updated_at files_url links comments].each do |attr|
            expect(json['question'].has_key?(attr)).to be_truthy
          end
        end

        it 'verifies that questions body was updated' do
          expect(json['question']['body']).to eq 'New body'
        end
      end

      context 'update with invalid attributes' do
        before { patch api_path, params: { access_token: author_access_token.token,
                                           question: { title: nil } },
                                           headers: headers  }

        it 'returns unprocessable status' do
          expect(response).to be_unprocessable
        end

        it 'verifies that questions body was not change' do
          question.reload
          expect(question.body).to eq '12t12'
        end
      end

      context 'unable to edit another users question' do
        before { put api_path, params: { access_token: access_token.token,
                                         question: { body: 'Edit' } },
                                         headers: headers  }

        it 'returns forbidden status' do
          expect(response).to be_forbidden
        end
      end
    end
  end
  describe 'DELETE /api/v1/questions/:id/' do
    let!(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:headers) { { "ACCEPT" => 'application/json' } }
    let(:author_access_token) { create(:access_token, resource_owner_id: question.user.id) }

    it_behaves_like 'API authorizable' do
      let(:method) { :delete }
    end

    it_behaves_like 'API resource deletable', Question
  end
end
