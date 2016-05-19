require 'rails_helper'

RSpec.describe Api::V1::PostsController, type: :controller do
  let(:my_user) { create(:user) }
  let(:my_topic) { create(:topic) }
  let(:my_post) { create(:post, topic: my_topic, user: my_user) }

  context "unauthenticated user" do

    it "PUT update returns http unauthenticated" do
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
      non_author = create(:user)
      controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(non_author.auth_token)
    end

    it "PUT update returns http forbidden for non-author" do
      put :update, id: my_post.id, post: {title: "Post Title", body: "Post Body"}
      expect(response).to have_http_status(403)
    end


    it "DELETE destroy returns http forbidden" do
      delete :destroy, id: my_post.id
      expect(response).to have_http_status(403)
    end
  end

  context "authenticated and authorized users" do
    before do
      controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(my_user.auth_token)
    end

    describe "POST create" do
      before {post :create, topic_id: my_topic.id, post: {title: "Post Title", body: RandomData.random_paragraph} }
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

  context "admin users" do
    before do
      admin_user = create(:user, role: :admin)
      controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(admin_user.auth_token)
    end

    describe "PUT update" do
      it "updates the post" do
        put :update, id: my_post.id, post: {title: "New Post Title", body: 'This is a new body for the post'}
        expect(response).to have_http_status(:success)
        expect(response.content_type).to eq 'application/json'
        json = JSON.parse(response.body)
        expect(json["title"]).to eq "New Post Title"
        expect(json["body"]).to eq "This is a new body for the post"
      end
    end
  end
end
