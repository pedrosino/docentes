class ColunasEdital < ActiveRecord::Migration
  def change
    add_column :editais, :situacao, :string
    add_column :editais, :num_processo, :string
  end
end
