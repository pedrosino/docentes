FactoryGirl.define do
  factory :area do
    nome { Faker::Lorem.sentence(2, true, 2) }
    campus { ['Educação Física', 'Glória', 'Monte Carmelo', 'Patos de Minas', 'Santa Mônica', 'Umuarama'].sample }
    vagas { Faker::Number.between(1, 5) }
    nome_vaga { Faker::Name.name }
    unidade_id { FactoryGirl.create(:unidade).id }
    prorrogar { false }

    trait :concurso do
      tipo 'concurso'
      regime { ['20', '40', 'DE'].sample }
      prova_didatica true
      tipo_vaga { vagas_efetivo.sample }
    end

    trait :processo do
      tipo 'processo'
      regime { ['20', '40'].sample }
      tipo_vaga { vagas_substituto.sample }
    end

    trait :prorrogada do
      prorrogar true
    end

    trait :graduacao do
      graduacao true
      descricao_graduacao { Faker::Lorem.paragraph }
    end

    trait :mestrado do
      mestrado true
      descricao_mestrado { Faker::Lorem.paragraph }
    end

    trait :doutorado do
      doutorado true
      descricao_doutorado { Faker::Lorem.paragraph }
    end

    trait :escrita_ok do
      after(:create) do |area|
        FactoryGirl.create(:criterio, :escrita, area_id: area.id, valor: 70)
        FactoryGirl.create(:criterio, :escrita, area_id: area.id, valor: 30)
        area.reload
      end
    end

    trait :didatica_ok do
      after(:create) do |area|
        FactoryGirl.create(:criterio, :didatica, area_id: area.id, valor: 60)
        FactoryGirl.create(:criterio, :didatica, area_id: area.id, valor: 40)
        area.reload
      end
    end

    trait :titulos_ok do
      concurso
      after(:create) do |area|
        FactoryGirl.create(:titulo, :atividades, area_id: area.id, valor: 5, maximo: 10)
        FactoryGirl.create(:titulo, :atividades, area_id: area.id, valor: 2, maximo: 10)

        FactoryGirl.create(:titulo, :producao, area_id: area.id, valor: 5, maximo: 40)
        FactoryGirl.create(:titulo, :producao, area_id: area.id, valor: 4, maximo: 40)
        area.coautoria = 100
        area.save!
        area.reload
      end
    end

    trait :verificada do
      graduacao
      doutorado
      escrita_ok
      didatica_ok
      titulos_ok
    end

    trait :confirmada do
      verificada
      after(:create) do |area|
        area.confirmada = true
        area.save!
      end
    end
  end
end
