class CreateUnidades < ActiveRecord::Migration
  def change
    create_table :unidades do |t|
      t.string :sigla, limit: 5
      t.string :nome
      t.string :email
      t.string :diretor

      t.timestamps null: false
    end
  end
end
