class AddPublicacaoEdital < ActiveRecord::Migration
  def change
    add_column :editais, :publicacao, :datetime
  end
end
