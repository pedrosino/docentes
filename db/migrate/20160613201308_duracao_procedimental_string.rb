class DuracaoProcedimentalString < ActiveRecord::Migration
  def change
    change_column :areas, :min_procedimental, :string
    change_column :areas, :max_procedimental, :string
  end
end
