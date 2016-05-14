class AddNameAndTypeToUser < ActiveRecord::Migration
  def change
    add_column :users, :nome, :text, null: false
    add_column :users, :tipo, :string, null: true
  end
end
