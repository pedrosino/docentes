class EspecificacaoQualificacao < ActiveRecord::Migration
  def change
    add_column :areas, :graduacao, :boolean
    add_column :areas, :descricao_graduacao, :text
    add_column :areas, :especializacao, :boolean
    add_column :areas, :descricao_especializacao, :text
    add_column :areas, :mestrado, :boolean
    add_column :areas, :descricao_mestrado, :text
    add_column :areas, :doutorado, :boolean
    add_column :areas, :descricao_doutorado, :text

    add_column :areas, :observacao, :text

    remove_column :areas, :qualificacao
  end
end
