require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => "application/json" } }
  describe 'GET api/v1/profiles/me' do
    it_behaves_like 'API authorizable' do
      let(:api_path) { '/api/v1/profiles/me' }
      let(:method) { :get }
    end
    context 'authorized' do
      let!(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      before { get '/api/v1/profiles/me', params: { access_token: access_token.token } }

      it 'returns 200 status' do
        expect(response).to be_successful
      end
      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json['user'][attr]).to eq me.send(attr).as_json
        end
      end
      it 'does not returns public fields' do
        %w[password encrypted_password].each do |attr|
          expect(json['user']).to_not have_key(attr)
        end
      end
    end
  end
end
