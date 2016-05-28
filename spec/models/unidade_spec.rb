require 'rails_helper'

describe Unidade do
  it "Factory valida" do
    expect(FactoryGirl.create :unidade).to be_valid
  end

  describe "criando unidade" do
    it "sigla tem 5 letras" do
      unidade = FactoryGirl.create :unidade
      unidade.sigla = "Oi"
      expect(unidade).to be_invalid
      unidade.sigla = "FACED"
      expect(unidade).to be_valid
    end
  end

end
