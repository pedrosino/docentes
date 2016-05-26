class CreateCriterios < ActiveRecord::Migration
  def change
    create_table :criterios do |t|
      t.string :nome
      t.text :descricao
      t.string :tipo_prova
      t.float :valor
      t.integer :area_id

      t.timestamps null: false
    end
  end
end
