class DataEditalDate < ActiveRecord::Migration
  def change
    change_column :editais, :data, :date
  end
end
