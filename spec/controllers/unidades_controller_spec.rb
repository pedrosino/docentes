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

      # it "add two options and confirm" do
      #   unidade = FactoryGirl.create(:unidade)
      #   post :update, id: unidade.id, unidade: { unidade_options_attributes: { "1" => {description: "Yes"}, "2" => {description: "No"} } }
      #   unidade.reload
      #   expect(unidade.unidade_options.length).to eq 2
      #   expect(unidade.unidade_options[0].description).to eq "Yes"
      #   expect(unidade.unidade_options[1].description).to eq "No"

      #   post :update, id: unidade.id, unidade: { question: unidade.question }, commit: "Confirm"
      #   unidade.reload
      #   expect(unidade.confirmed?).to eq true
      # end

      # it "removes an option and try to confirm" do
      #   unidade = FactoryGirl.create(:unidade)
      #   post :update, id: unidade.id, unidade: { unidade_options_attributes: { "1" => {description: "Yes"}, "2" => {description: "No"} } }
      #   unidade.reload
      #   second_option_id = unidade.unidade_options[1].id
      #   post :update, id: unidade.id, unidade: { unidade_options_attributes: { "3" => {id: unidade.unidade_options.first.id, _destroy: true} } }
      #   unidade.reload
      #   expect(unidade.unidade_options.length).to eq 1
      #   expect(unidade.unidade_options.first.id).to eq second_option_id
      #   expect(unidade.unidade_options.first.description).to eq "No"

      #   post :update, id: unidade.id, unidade: { question: unidade.question }, commit: "Confirm"
      #   unidade.reload
      #   expect(unidade.confirmed?).to eq false
      # end

      # it "can't edit a confirmed unidade, except for deadline" do
      #   unidade = FactoryGirl.create(:unidade, :confirmed)
      #   post :update, id: unidade.id, unidade: { multiple: true }
      #   invalid_unidade = assigns :unidade
      #   unidade.reload
      #   expect(unidade.multiple).to eq false
      #   expect(invalid_unidade.errors[:deadline]).to eq ["you can only change the deadline"]
      # end

      # it "can change deadline of a confirmed unidade" do
      #   unidade = FactoryGirl.create(:unidade, :confirmed)
      #   new_deadline = Date.today - 1
      #   post :update, id: unidade.id, unidade: { deadline: new_deadline }
      #   unidade.reload
      #   expect(unidade.deadline).to eq new_deadline
      # end

      # it "can delete an unconfirmed unidade" do
      #   unidade = FactoryGirl.create(:unidade)
      #   post :destroy, id: unidade.id
      #   expect(unidade.find_by_id(unidade.id)).to eq nil
      # end

      # it "can't delete a confirmed unidade" do
      #   unidade = FactoryGirl.create(:unidade, :confirmed)
      #   post :destroy, id: unidade.id
      #   expect(unidade.find_by_id(unidade.id)).not_to eq nil
      # end

      # it "deadline defaults to now if you don't change it" do
      #   unidade = FactoryGirl.create(:unidade)
      #   post :update, id: unidade.id, unidade: { deadline: unidade.deadline, unidade_options_attributes: { "1" => {description: "Yes"}, "2" => {description: "No"} } }
      #   new_unidade = assigns :unidade
      #   unidade.reload
      #   expect(new_unidade.deadline).to eq unidade.deadline
      # end
    end
  end

end
