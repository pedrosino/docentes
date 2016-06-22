require 'rails_helper'

describe Post do
  it "Factory valida" do
    expect(FactoryGirl.create(:post)).to be_valid
  end

  describe "criando post" do
    it "slug correto" do
      post = FactoryGirl.create :post
      expect(post.slug).to eq (post.titulo + post.data.to_s).parameterize
    end
  end
end
