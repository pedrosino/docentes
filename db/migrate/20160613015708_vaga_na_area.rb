class VagaNaArea < ActiveRecord::Migration
  def change
    add_column :areas, :tipo_vaga, :string
    add_column :areas, :nome_vaga, :string
  end
end
