class CreateEditais < ActiveRecord::Migration
  def change
    create_table :editais do |t|
      t.string :numero
      t.string :data
      t.datetime :comeca_inscricao
      t.datetime :termina_inscricao
      t.string :tipo

      t.timestamps null: false
    end
    add_column :unidades, :telefone, :string
    add_column :areas, :disciplinas, :text
    add_column :areas, :prova_didatica, :boolean
    add_column :areas, :prova_procedimental, :boolean
  end
end
