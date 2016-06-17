require 'rails_helper'

describe Vaga do
  it "Factory valida" do
    expect(FactoryGirl.create(:vaga)).to be_valid
  end

  describe "criando vaga" do
    it "situacao tem valores possiveis" do
      vaga = FactoryGirl.create :vaga
      vaga.situacao = "Oi"
      expect(vaga).to be_invalid
      vaga.situacao = "a"
      expect(vaga).to be_valid
      vaga.situacao = nil
      expect(vaga).to be_valid
    end
  end
end
