require 'rails_helper'

RSpec.describe Api::V1::CommentsController, type: :controller do
  let(:my_user) { create(:user) }
  let(:my_post) { create(:post) }
  let(:my_comment) { Comment.create!(body: RandomData.random_sentence, post: my_post, user: my_user) }

  context "unauthenticated user" do
    it "GET index returns success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "GET show returns http success" do
      get :show, id: my_comment.id
      expect(response).to have_http_status(:success)
    end

    it "GET show returns comments" do
      get :show, id: my_comment.id
      hashed_response = JSON.parse response.body
      expect(hashed_response['id']).to eq my_comment.id
      expect(hashed_response['body']).to eq my_comment.body
    end
  end

  context "unauthorized user" do
    before do
      controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(my_user.auth_token)
    end

    it "GET index returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "GET show returns http success" do
      get :show, id: my_comment.id
      expect(response).to have_http_status(:success)
    end

    it "GET show returns comments" do
      get :show, id: my_comment.id
      hashed_response = JSON.parse response.body
      expect(hashed_response['id']).to eq my_comment.id
      expect(hashed_response['body']).to eq my_comment.body
    end
  end
end
