shared_examples 'API resource deletable' do |target|
  context 'cannot destroy another users question' do
    let(:not_author_action) { delete api_path, params: { access_token: access_token.token }, headers: headers  }

    it 'destroys other users resource' do
      expect { not_author_action }.to_not change(target, :count)
    end

    it 'returns :forbidden status' do
      not_author_action

      expect(response).to be_forbidden
    end
  end

  context 'author destroys own resource' do
    let(:author_action) { delete api_path, params: { access_token: author_access_token.token }, headers: headers  }

    it 'successfully destroys resource' do
      expect { author_action }.to change(target, :count).by(-1)
    end

    it 'returns 200 status' do
      author_action

      expect(response).to be_successful
    end
  end
end
