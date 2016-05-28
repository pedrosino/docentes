require 'rails_helper'

describe Area do
  it "Factory valida" do
    expect(FactoryGirl.create :area).to be_valid
  end

  describe "criando area" do
    area = FactoryGirl.create :area
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
      area = FactoryGirl.create :area
      area.tipo = 'concurso'
      area.update(prova_didatica: false)
      area.update(proximo: "titulos")
      expect(area).to be_invalid
    end

    # Testar soma da prova escrita
    it "prova escrita precisa de criterios" do
      area = FactoryGirl.create :area
      area.update(proximo: "didatica")
      expect(area.errors.messages).to eq({base: ["Você deve preencher os critérios da prova escrita."]})
    end

    it "soma dos criterios deve ser 100" do
      area = FactoryGirl.create :area
      area.criterios << FactoryGirl.create(:criterio, :escrita, area_id: area.id)
      area.update(proximo: "didatica")
      expect(area.errors.messages).to eq({base: ["A soma dos critérios não atinge 100 pontos."]})

      # Atualiza valor do primeiro criterio
      area.criterios.first.valor = 50
      area.criterios << FactoryGirl.create(:criterio, :escrita, area_id: area.id, valor: 30)
      area.criterios << FactoryGirl.create(:criterio, :escrita, area_id: area.id, valor: 20)
      area.update(proximo: "didatica")
      expect(area).to be_valid
    end

    # Testar soma da prova didatica

    # Testar soma da prova procedimental
  end

end
