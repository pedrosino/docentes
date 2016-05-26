class CreateCriterios < ActiveRecord::Migration
  def change
    create_table :criterios do |t|
      t.nome :string
      t.descricao :text
      t.tipo_prova :string
      t.valor :float
      t.area_id :integer

      t.timestamps null: false
    end
  end
end
