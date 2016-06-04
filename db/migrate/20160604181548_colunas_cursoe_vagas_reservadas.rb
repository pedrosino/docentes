class ColunasCursoeVagasReservadas < ActiveRecord::Migration
  def change
    add_column :areas, :curso, :string, null: true
    add_column :areas, :vagas_negros, :integer
    add_column :areas, :vagas_pcd, :integer
  end
end
