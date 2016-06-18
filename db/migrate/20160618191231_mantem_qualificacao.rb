class MantemQualificacao < ActiveRecord::Migration
  def change
    add_column :areas, :mantem_qualificacao, :boolean
  end
end
