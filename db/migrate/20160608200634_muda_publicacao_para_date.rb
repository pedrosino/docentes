class MudaPublicacaoParaDate < ActiveRecord::Migration
  def change
    change_column :editais, :publicacao, :date
  end
end
