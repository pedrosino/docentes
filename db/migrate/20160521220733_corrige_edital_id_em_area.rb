class CorrigeEditalIdEmArea < ActiveRecord::Migration
  def change
    rename_column :areas, :edital, :editai_id
  end
end
