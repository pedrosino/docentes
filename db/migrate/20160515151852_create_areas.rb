class CreateAreas < ActiveRecord::Migration
  def change
    create_table :areas do |t|
      t.integer :unidade_id
      t.string :campus
      t.string :nome
      t.string :subarea
      t.text :qualificacao
      t.string :regime
      t.integer :vagas
      t.boolean :prorrogar
      t.text :qualif_prorrogar
      t.datetime :data_prova
      t.string :tipo
      t.string :edital

      t.timestamps null: false
    end
    add_foreign_key :areas, :unidades
  end
end
