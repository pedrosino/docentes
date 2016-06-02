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

      let(:edital) { FactoryGirl.create :edital }
      it "edita um edital" do
        post :update, id: edital.id, edital: { data: "01 de junho de 2016", publicacao: "2016-06-03" }
        edital.reload
        expect(edital.data).to eq "01 de junho de 2016"
        expect(edital.publicacao).to eq "2016-06-03"
      end

      it "exclui um edital" do
        post :destroy, id: edital.id
        expect(Edital.find_by_id(edital.id)).to eq nil
      end

      it "inclui areas" do
        area1 = FactoryGirl.create(:area)
        area2 = FactoryGirl.create(:area)
        post :update, id: edital.id, edital: { tipo: edital.tipo }, areas: [area1.id.to_s, area2.id.to_s]
        edital.reload
        expect(edital.areas.length).to eq 2
      end

      it "remove uma area e depois todas" do
        area1 = FactoryGirl.create(:area, edital_id: edital.id)
        area2 = FactoryGirl.create(:area, edital_id: edital.id)
        area3 = FactoryGirl.create(:area, edital_id: edital.id)
        expect(edital.areas.length).to eq 3
        post :update, id: edital.id, edital: { tipo: edital.tipo }, areas: [area1.id.to_s, area2.id.to_s]
        edital.reload
        expect(edital.areas.length).to eq 2
        expect(edital.areas.map(&:id)).not_to include(area3.id)
        post :update, id: edital.id, edital: { tipo: edital.tipo }, areas: []
        edital.reload
        expect(edital.areas.length).to eq 0
      end
    end
  end

end
