class TitulosProrrogacao < ActiveRecord::Migration
  def change
    add_column :titulos, :prorrogacao, :boolean, default: false
  end
end
