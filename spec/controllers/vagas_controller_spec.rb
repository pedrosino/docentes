require 'rails_helper'

describe VagasController do
  context "nao esta logado" do
    it "redireciona para login" do
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context "logado como usuario da unidade" do
    it "redireciona para login" do
      sign_in FactoryGirl.create(:user_unidade)
      post :create
      expect(response).to redirect_to(root_url)
    end
  end

  context "logado como usuario da progep" do
    let(:user_progep) { FactoryGirl.create :user_progep }
    before :each do
      sign_in user_progep
    end

    describe "POSTS" do
      it "cria uma vaga" do
        post :create, vaga: { tipo: "Exoneração", nome: "Dom Pedro II" }
        vaga = assigns(:vaga)
        expect(response).to redirect_to edit_vaga_path(vaga)
        expect(vaga.tipo).to eq "Exoneração"
        expect(vaga.nome).to eq "Dom Pedro II"
      end

      it "edita uma vaga" do
        vaga = FactoryGirl.create(:vaga)
        post :update, id: vaga.id, vaga: { tipo: "Aposentadoria", nome: "Michael Jordan" }
        vaga.reload
        expect(vaga.tipo).to eq "Aposentadoria"
        expect(vaga.nome).to eq "Michael Jordan"
      end

      it "exclui uma vaga" do
        vaga = FactoryGirl.create(:vaga)
        post :destroy, id: vaga.id
        expect(Vaga.find_by_id(vaga.id)).to eq nil
      end
    end
  end
end
