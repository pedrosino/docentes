class CreateTitulos < ActiveRecord::Migration
  def change
    create_table :titulos do |t|
      t.text :descricao
      t.float :valor
      t.float :maximo
      t.string :tipo
      t.string :unidade_medida
      t.integer :area_id

      t.timestamps null: false
    end
  end
end
