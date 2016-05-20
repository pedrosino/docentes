class CorrigeNomeECriaChavesEstrangeiras < ActiveRecord::Migration
  def change
    change_column :users, :nome, :string

    add_foreign_key :users, :unidades
    add_foreign_key :areas, :unidades
  end
end
