class AddResponsavelESituacaoArea < ActiveRecord::Migration
  def change
    add_column :areas, :responsavel, :string
    add_column :areas, :situacao, :string
  end
end
