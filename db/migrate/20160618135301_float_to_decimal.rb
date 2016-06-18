class FloatToDecimal < ActiveRecord::Migration
  def change
    change_column :criterios, :valor, :decimal, precision: 6, scale: 3
    change_column :titulos, :valor, :decimal, precision: 6, scale: 3
    change_column :titulos, :maximo, :decimal, precision: 6, scale: 3
  end
end
