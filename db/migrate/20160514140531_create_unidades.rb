class CreateUnidades < ActiveRecord::Migration
  def change
    create_table :unidades do |t|
      t.text :sigla
      t.text :nome
      t.text :email
      t.text :diretor

      t.timestamps null: false
    end
  end
end
