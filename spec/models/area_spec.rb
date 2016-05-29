require 'rails_helper'

describe Area do
  it "Factory valida" do
    expect(FactoryGirl.create :area).to be_valid
  end

  let(:area) { FactoryGirl.create :area }

  describe "criando area" do
    it "tipo do edital" do
      area.tipo = "Oi"
      expect(area).to be_invalid
      area.tipo = "concurso"
      expect(area).to be_valid
    end

    it "regime de trabalho" do
      area.regime = "oi"
      expect(area).to be_invalid
      area.regime = '20'
      expect(area).to be_valid
    end

    it "numero de vagas" do
      area.vagas = nil
      expect(area).to be_invalid
      area.vagas = 1
      expect(area).to be_valid
    end
  end

  describe "editando area" do
    it "concurso tem prova didatica" do
      area.tipo = 'concurso'
      area.prova_didatica = false
      area.proximo = "titulos"
      expect(area).to be_invalid
    end

    # Testar soma da prova escrita
    it "prova escrita precisa de criterios" do
      area.proximo = "didatica"
      area.valid?
      expect(area.errors.messages).to eq({base: ["Você deve preencher os critérios da prova escrita."]})
    end

    it "soma dos criterios deve ser 100" do
      FactoryGirl.create(:criterio, :escrita, area_id: area.id, valor: 50)
      area.proximo = "didatica"
      area.valid?
      expect(area.errors.messages).to eq({base: ["A soma dos critérios não atinge 100 pontos."]})

      # Cria mais criterios
      FactoryGirl.create(:criterio, :escrita, area_id: area.id, valor: 30)
      FactoryGirl.create(:criterio, :escrita, area_id: area.id, valor: 20)
      # A associação fica em cache, então precisa resetar
      area.criterios.reset
      expect(area).to be_valid
    end

    # Testar soma da prova didatica

    # Testar soma da prova procedimental
  end

end
