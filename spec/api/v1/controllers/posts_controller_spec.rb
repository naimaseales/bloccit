require 'rails_helper'

RSpec.describe Api::V1::PostsController, type: :controller do
  let(:my_user) { create(:user) }
  let(:my_topic) { create(:topic) }
  let(:my_post) { create(:post, topic: my_topic, user: my_user) }

  context "unauthenticated user" do
    before do
      controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(my_user.auth_token)
    end

    it "PUT update returns http unauthenticated" do
      new_post = build(:post)
      put :update, id: my_post.id, post: {title: "Post Title", body: "Post Body"}
      expect(response).to have_http_status(401)
    end

    it "POST create returns http unauthenticated" do
      new_post = build(:post)
      post :create, post: {title: "Post Title", body: "Post Body"}
      expect(response).to have_http_status(401)
    end

    it "DELETE destroy returns http unauthenticated" do
      delete :destroy, id: my_post.id
      expect(response).to have_http_status(401)
    end
  end

  context "unauthorized user" do
    before do
      controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(my_user.auth_token)
    end

    it "PUT update returns http forbidden" do
      new_post = build(:post)
      put :update, id: my_post.id, post: {title: "Post Title", body: "Post Body"}
      expect(response).to have_http_status(403)
    end

    it "POST create returns http forbidden" do
      new_post = build(:post)
      post :create, topic_id: my_topic.id, post: {title: "Post Title", body: "Post Body"}
      expect(response).to have_http_status(403)
    end

    it "DELETE destroy returns http forbidden" do
      delete :destroy, id: my_post.id
      expect(response).to have_http_status(403)
    end
  end

  context "unauthenticated and authorized users" do
    describe "POST create" do

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "returns json content type" do
        expect(response.content_type).to eq 'application/json'
      end
    end

    describe "DELETE destroy" do
      before { delete :destroy, id: my_post.id }

      it "returns https success" do
        expect(response).to have_http_status(:success)
      end

      it "returns json content type" do
        expect(response.content_type).to eq 'application/json'
      end
    end
  end
end
