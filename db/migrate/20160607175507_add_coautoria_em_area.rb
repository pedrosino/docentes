class AddCoautoriaEmArea < ActiveRecord::Migration
  def change
    add_column :areas, :coautoria, :integer
  end
end
