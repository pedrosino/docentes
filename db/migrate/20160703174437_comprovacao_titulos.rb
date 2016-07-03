class ComprovacaoTitulos < ActiveRecord::Migration
  def change
    add_column :titulos, :comprovacao, :text
  end
end
