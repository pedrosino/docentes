class DuracaoProvaProcedimental < ActiveRecord::Migration
  def change
    add_column :areas, :min_procedimental, :integer, null: true
    add_column :areas, :max_procedimental, :integer, null: true
  end
end
