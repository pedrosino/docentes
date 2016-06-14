class DatasDaVaga < ActiveRecord::Migration
  def change
    add_column :vagas, :data_inicio, :date
    add_column :vagas, :data_fim, :date
    add_column :vagas, :regime, :string
    add_column :vagas, :campus, :string
    add_column :vagas, :observacao, :text
  end
end
