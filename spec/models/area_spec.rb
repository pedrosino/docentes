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
      expect(area.errors.messages).to eq({base: ["A soma dos critérios da prova escrita não atinge 100 pontos."]})

      # Cria mais criterios
      FactoryGirl.create(:criterio, :escrita, area_id: area.id, valor: 30)
      FactoryGirl.create(:criterio, :escrita, area_id: area.id, valor: 20)
      # A associação fica em cache, então precisa resetar
      area.criterios.reset
      expect(area).to be_valid
    end

    # Testar soma da prova didatica
    it "prova didatica precisa de criterios" do
      area.proximo = "titulos"
      area.tipo = 'processo'
      area.prova_didatica = true
      area.valid?
      expect(area.errors.messages).to eq({base: ["Você deve preencher os critérios da prova didática pedagógica."]})
    end

    it "soma dos criterios deve ser 100" do
      FactoryGirl.create(:criterio, :didatica, area_id: area.id, valor: 30)
      area.proximo = "titulos"
      area.tipo = 'processo'
      area.prova_didatica = true
      area.valid?
      expect(area.errors.messages).to eq({base: ["A soma dos critérios da prova didática pedagógica não atinge 100 pontos."]})

      # Cria mais criterios
      FactoryGirl.create(:criterio, :didatica, area_id: area.id, valor: 30)
      FactoryGirl.create(:criterio, :didatica, area_id: area.id, valor: 40)
      # A associação fica em cache, então precisa resetar
      area.criterios.reset
      expect(area).to be_valid
    end

    # Testar soma da prova procedimental
    it "prova procedimental precisa de criterios" do
      area.proximo = "titulos"
      area.tipo = 'processo'
      area.prova_procedimental = true
      area.valid?
      expect(area.errors.messages).to eq({base: ["Você deve preencher os critérios da prova didática procedimental."]})
    end

    it "soma dos criterios deve ser 100" do
      FactoryGirl.create(:criterio, :procedimental, area_id: area.id, valor: 35)
      area.proximo = "titulos"
      area.tipo = 'processo'
      area.prova_procedimental = true
      area.valid?
      expect(area.errors.messages).to eq({base: ["A soma dos critérios da prova didática procedimental não atinge 100 pontos."]})

      # Cria mais criterios
      FactoryGirl.create(:criterio, :procedimental, area_id: area.id, valor: 20)
      FactoryGirl.create(:criterio, :procedimental, area_id: area.id, valor: 45)
      # A associação fica em cache, então precisa resetar
      area.criterios.reset
      expect(area).to be_valid
    end
  end

  describe "reserva de vagas" do
    it "uma vaga nao tem reserva" do
      area.vagas = 1
      area.save
      expect(area.vagas_negros).to eq 0
      expect(area.vagas_pcd).to eq 0
    end
    it "2 vagas nao tem reserva" do
      area.vagas = 2
      area.save
      expect(area.vagas_negros).to eq 0
      expect(area.vagas_pcd).to eq 0
    end
    it "com 3 vagas => reserva 1 para negros" do
      area.vagas = 3
      area.save
      expect(area.vagas_negros).to eq 1
      expect(area.vagas_pcd).to eq 0
    end
    it "com 5 vagas => reserva 1 para negros e 1 para pessoas com deficiencia" do
      area.vagas = 5
      area.save
      expect(area.vagas_negros).to eq 1
      expect(area.vagas_pcd).to eq 1
    end
    it "com 8 vagas => reserva 2 para negros e 1 para pessoas com deficiencia" do
      area.vagas = 8
      area.save
      expect(area.vagas_negros).to eq 2
      expect(area.vagas_pcd).to eq 1
    end
    it "com 11 vagas => reserva 2 para negros e 2 para pessoas com deficiencia" do
      area.vagas = 11
      area.save
      expect(area.vagas_negros).to eq 2
      expect(area.vagas_pcd).to eq 2
    end
    it "com 13 vagas => reserva 3 para negros e 2 para pessoas com deficiencia" do
      area.vagas = 13
      area.save
      expect(area.vagas_negros).to eq 3
      expect(area.vagas_pcd).to eq 2
    end
    it "com 18 vagas => reserva 4 para negros e 2 para pessoas com deficiencia" do
      area.vagas = 18
      area.save
      expect(area.vagas_negros).to eq 4
      expect(area.vagas_pcd).to eq 2
    end
    it "com 21 vagas => reserva 4 para negros e 3 para pessoas com deficiencia" do
      area.vagas = 21
      area.save
      expect(area.vagas_negros).to eq 4
      expect(area.vagas_pcd).to eq 3
    end
    it "com 23 vagas => reserva 5 para negros e 3 para pessoas com deficiencia" do
      area.vagas = 23
      area.save
      expect(area.vagas_negros).to eq 5
      expect(area.vagas_pcd).to eq 3
    end
    it "com 60 vagas => reserva 12 para negros e 6 para pessoas com deficiencia" do
      area.vagas = 60
      area.save
      expect(area.vagas_negros).to eq 12
      expect(area.vagas_pcd).to eq 6
    end
  end

end
