require 'rails_helper'

describe Edital do
  it "Factory valida" do
    expect(FactoryGirl.create(:edital)).to be_valid
  end

  describe "criando edital" do
    it "numero deve conter ano" do
      edital = FactoryGirl.create :edital
      edital.numero = "Oi"
      expect(edital).to be_invalid
      edital.numero = "Oi/2099"
      expect(edital).to be_valid
    end
  end
end
