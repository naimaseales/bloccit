require 'rails_helper'

RSpec.describe SponsoredPost, type: :model do
  let(:title) { RandomData.random_sentence }
  let(:body) { RandomData.random_paragraph }
  let(:price) { 10.0 }
  let(:topic) { Topic.create!(name: RandomData.random_sentence, description: RandomData.random_paragraph)}
  let(:sponsored_post) { topic.sponsored_posts.create!(title: title, body: body, price: 100) }

  it { is_expected.to belong_to(:topic) }

  describe "attributes" do
    it "has title, body and price attributes" do
      expect(sponsored_post).to have_attributes(title: title, body: body, price: price)
    end
  end

end
