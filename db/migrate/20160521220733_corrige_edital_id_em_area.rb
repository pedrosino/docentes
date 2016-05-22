class CorrigeEditalIdEmArea < ActiveRecord::Migration
  def change
    rename_column :areas, :edital, :edital_id
  end
end
