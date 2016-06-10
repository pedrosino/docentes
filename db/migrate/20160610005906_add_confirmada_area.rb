class AddConfirmadaArea < ActiveRecord::Migration
  def change
    add_column :areas, :confirmada, :boolean
  end
end
