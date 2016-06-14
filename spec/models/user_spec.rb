require 'rails_helper'

describe User do
  it "Factory valida" do
    expect(FactoryGirl.create :user).to be_valid
  end

  describe "cria usuarios" do
    it "usuario da progep" do
      user_progep = FactoryGirl.create :user_progep
      expect(user_progep.email).to eq 'progep@ufu.br'
      expect(user_progep.tipo).to eq 'p'
      expect(user_progep.nome).to eq 'PROGEP'
    end

    it "user_unidade" do
      user_unidade = FactoryGirl.create :user_unidade
      expect(user_unidade.email).to eq 'facxy@ufu.br'
      expect(user_unidade.tipo).to eq 'u'
      expect(user_unidade.nome).to eq 'Faculdade XY'
    end

    it "usuario com unidade" do
      unidade = FactoryGirl.create :unidade, sigla: "PEDRO"
      user_u = FactoryGirl.create :user, :com_unidade, sigla_unidade: unidade.sigla, unidade_id: unidade.id
      expect(user_u.email).to eq 'pedro@ufu.br'
      expect(user_u.unidade_id).to eq unidade.id
      expect(user_u.tipo).to eq 'u'
    end
  end

end
