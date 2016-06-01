require 'rails_helper'

describe EditaisController do

  context "nao esta logado" do
    it "redireciona para login" do
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context "logado como usuario da edital" do
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
      it "cria um edital" do
        post :create, edital: { tipo: "concurso", numero: "001/2016" }
        edital = assigns(:edital)
        expect(response).to redirect_to edit_edital_path(edital)
        expect(edital.numero).to eq "001/2016"
        expect(edital.tipo).to eq "concurso"
      end

      it "edita um edital" do
        edital = FactoryGirl.create(:edital)
        post :update, id: edital.id, edital: { data: "01 de junho de 2016", publicacao: "2016-06-03" }
        edital.reload
        expect(edital.data).to eq "01 de junho de 2016"
        expect(edital.publicacao).to eq "2016-06-03"
      end

      it "exclui um edital" do
        edital = FactoryGirl.create(:edital)
        post :destroy, id: edital.id
        expect(Edital.find_by_id(edital.id)).to eq nil
      end
    end
  end

end
