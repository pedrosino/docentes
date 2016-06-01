require 'rails_helper'

describe UnidadesController do

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
      it "cria uma unidade" do
        post :create, unidade: { sigla: "Hello" }
        unidade = assigns(:unidade)
        expect(response).to redirect_to edit_unidade_path(unidade)
        expect(unidade.sigla).to eq "Hello"
      end

      it "edita uma unidade" do
        unidade = FactoryGirl.create(:unidade)
        post :update, id: unidade.id, unidade: { sigla: "Pedro", nome: "Faculdade do Pedro" }
        unidade.reload
        expect(unidade.sigla).to eq "Pedro"
        expect(unidade.nome).to eq "Faculdade do Pedro"
      end

      it "exclui uma unidade" do
        unidade = FactoryGirl.create(:unidade)
        post :destroy, id: unidade.id
        expect(Unidade.find_by_id(unidade.id)).to eq nil
      end
    end
  end

end
