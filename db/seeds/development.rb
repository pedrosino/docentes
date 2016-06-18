# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# ruby encoding: utf-8

unidades = [
  ['ESEBA', 'Escola de Educação Básica'],
  ['ESTES', 'Escola Técnica de Saúde'],
  ['FACED', 'Faculdade de Educação'],
  ['FACIC', 'Faculdade de Ciências Contábeis'],
  ['FACIP', 'Faculdade de Ciências Integradas do Pontal'],
  ['FACOM', 'Faculdade de Computação'],
  ['FADIR', 'Faculdade de Direito'],
  ['FAEFI', 'Faculdade de Educação Física e Fisioterapia'],
  ['FAGEN', 'Faculdade de Gestão e Negócios'],
  ['FAMAT', 'Faculdade de Matemática'],
  ['FAMED', 'Faculdade de Medicina'],
  ['FAMEV', 'Faculdade de Medicina Veterinária'],
  ['FAUED', 'Faculdade de Arquitetura e Urbanismo e Design'],
  ['FECIV', 'Faculdade de Engenharia Civil'],
  ['FEELT', 'Faculdade de Engenharia Elétrica'],
  ['FEMEC', 'Faculdade de Engenharia Mecânica'],
  ['FEQUI', 'Faculdade de Engenharia Química'],
  ['FOUFU', 'Faculdade de Odontologia'],
  ['IARTE', 'Instituto de Artes'],
  ['ICBIM', 'Instituto de Ciências Biomédicas'],
  ['ICIAG', 'Instituto de Ciências Agrárias'],
  ['IEUFU', 'Instituto de Economia'],
  ['IFILO', 'Instituto de Filosofia'],
  ['IGUFU', 'Instituto de Geografia'],
  ['ILEEL', 'Instituto de Letras e Linguística'],
  ['INBIO', 'Instituto de Biologia'],
  ['INCIS', 'Instituto de Ciências Sociais'],
  ['INFIS', 'Instituto de Física'],
  ['INGEB', 'Instituto de Genética e Bioquímica'],
  ['INHIS', 'Instituto de História'],
  ['IPUFU', 'Instituto de Psicologia'],
  ['IQUFU', 'Instituto de Química']
]

unidades.each do |sigla, nome|
  unidade = Unidade.create(sigla: sigla, nome: nome)
  FactoryGirl.create :user, :com_unidade, sigla_unidade: unidade.sigla, unidade_id: unidade.id
end

# Usuários
FactoryGirl.create(:user_progep)
User.create(email: 'pedrosg@ufu.br', password: 'pedroufu', password_confirmation: 'pedroufu', nome: 'Pedro', tipo: 'a')
User.create(email: 'louane@ufu.br', password: 'louaneufu', password_confirmation: 'louaneufu', nome: 'Louane', tipo: 'p')

# Áreas
5.times do
  FactoryGirl.create(:area, :processo, unidade_id: Unidade.all.sample.id)
  FactoryGirl.create(:area, :concurso, unidade_id: Unidade.all.sample.id)
  FactoryGirl.create(:area, :concurso, :escrita_ok, unidade_id: Unidade.all.sample.id)
  FactoryGirl.create(:area, :concurso, :didatica_ok, unidade_id: Unidade.all.sample.id)
  FactoryGirl.create(:area, :concurso, :titulos_ok, unidade_id: Unidade.all.sample.id)
  FactoryGirl.create(:area, :verificada, unidade_id: Unidade.all.sample.id)
  FactoryGirl.create(:area, :enviada, unidade_id: Unidade.all.sample.id)
end

# Editais
Area.all.select(&:confirmada).each do |area|
  edital = FactoryGirl.create(:edital, tipo: area.tipo)
  area.edital_id = edital.id
  area.save!
end

# Vagas
10.times do
  FactoryGirl.create(:vaga, :efetivo, unidade_id: Unidade.all.sample.id)
  FactoryGirl.create(:vaga, :substituto, unidade_id: Unidade.all.sample.id)
end
