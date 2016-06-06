class MudaInscricaoParaDate < ActiveRecord::Migration
  def change
    change_column :editais, :comeca_inscricao, :date
    change_column :editais, :termina_inscricao, :date
  end
end
