require 'rails_helper'

describe AreasController do

  context "nao esta logado" do
    it "redireciona para login" do
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context "logado como usuario da unidade" do
    let(:user_unidade) { FactoryGirl.create :user_unidade }
    before :each do
      sign_in user_unidade
    end

    describe "POSTS" do
      it "cria uma area" do
        post :create, area: { tipo: "concurso" }
        area = assigns(:area)
        expect(response).to redirect_to editar_area_path(area)
        expect(area.tipo).to eq "concurso"
      end

      it "edita uma area" do
        area = FactoryGirl.create(:area)
        post :update, id: area.id, area: { nome: "Pedro", campus: "Santa Mônica", qualificacao: "Doutorado", regime: "20", vagas: "1" }
        area.reload
        expect(area.nome).to eq "Pedro"
        expect(area.campus).to eq "Santa Mônica"
        expect(area.qualificacao).to eq "Doutorado"
        expect(area.regime).to eq "20"
        expect(area.vagas).to eq 1
      end

      it "exclui uma area" do
        area = FactoryGirl.create(:area)
        post :destroy, id: area.id
        expect(Area.find_by_id(area.id)).to eq nil
      end
    end
  end

  context "logado como usuario da progep" do
    let(:user_progep) { FactoryGirl.create :user_progep }
    before :each do
      sign_in user_progep
    end

    describe "POSTS" do
      it "cria uma area" do
        post :create, area: { tipo: "concurso" }
        area = assigns(:area)
        expect(response).to redirect_to editar_area_path(area)
        expect(area.tipo).to eq "concurso"
      end

      it "edita uma area" do
        area = FactoryGirl.create(:area)
        post :update, id: area.id, area: { nome: "Pedro", campus: "Santa Mônica", qualificacao: "Doutorado", regime: "20", vagas: "1" }
        area.reload
        expect(area.nome).to eq "Pedro"
        expect(area.campus).to eq "Santa Mônica"
        expect(area.qualificacao).to eq "Doutorado"
        expect(area.regime).to eq "20"
        expect(area.vagas).to eq 1
      end

      it "exclui uma area" do
        area = FactoryGirl.create(:area)
        post :destroy, id: area.id
        expect(Area.find_by_id(area.id)).to eq nil
      end
    end
  end

end
