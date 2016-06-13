class CreateVagas < ActiveRecord::Migration
  def change
    create_table :vagas do |t|
      t.integer :codigo
      t.string :tipo
      t.string :nome
      t.integer :unidade_id
      t.string :situacao

      t.timestamps null: false
    end

    add_column :areas, :vaga_id, :integer
  end
end
