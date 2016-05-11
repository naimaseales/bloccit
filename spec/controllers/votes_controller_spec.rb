require 'rails_helper'
include SessionsHelper

RSpec.describe VotesController, type: :controller do
  let(:my_topic) { create(:topic) }
  let(:my_user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:user_post) { create(:post, topic: my_topic, user: other_user) }
  let(:my_vote) { Vote.create!(value: 1) }

  context "guest" do
    describe "POST up_vote" do
      it "redirects the user to the sign in view" do
        post :up_vote, format: :js, post_id: user_post.id
        expect(response).to redirect_to(new_session_path)
      end
    end

    describe "POST down_votes" do
      it "redirects the user to the sign in view" do
        post :down_vote, format: :js, post_id: user_post.id
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  context "signed in user" do
    before do
      create_session(my_user)
      request.env["HTTP_REFERER"] = topic_post_path(my_topic, user_post)
    end

    describe "POST up_vote" do
      it "the users first vote increases number of post vote by one" do
        votes = user_post.votes.count
        post :up_vote, format: :js, post_id: user_post.id
        expect(user_post.votes.count).to eq(votes + 1)
      end

      it "the users second vote does not increase the number of votes" do
        post :up_vote, format: :js, post_id: user_post.id
        votes = user_post.votes.count
        post :up_vote, format: :js, post_id: user_post.id
        expect(user_post.votes.count).to eq(votes)
      end

      it "increases the sum of post votes by one" do
        points = user_post.points
        post :up_vote, format: :js, post_id: user_post.id
        expect(user_post.points).to eq(points + 1)
      end

      it "renders up_vote.js.erb" do
        post :up_vote, format: :js, post_id: user_post.id
        expect(response).to render_template :up_vote
      end
    end

    describe "POST down_vote" do
      it "the users first vote increases number of post votes by one" do
        votes = user_post.votes.count
        post :down_vote, format: :js, post_id: user_post.id
        expect(user_post.votes.count).to eq(votes + 1)
      end

      it "the users second vote does not increase the number of votes" do
        post :down_vote, format: :js, post_id: user_post.id
        votes = user_post.votes.count
        post :down_vote, format: :js, post_id: user_post.id
        expect(user_post.votes.count).to eq(votes)
      end

      it "decreases the sum of post votes by one" do
        points = user_post.points
        post :down_vote, format: :js, post_id: user_post.id
        expect(user_post.points).to eq(points - 1)
      end

      it "renders down_vote.js.erb" do
        post :down_vote, format: :js, post_id: user_post.id
        expect(response).to render_template :down_vote
      end
    end
  end
end
