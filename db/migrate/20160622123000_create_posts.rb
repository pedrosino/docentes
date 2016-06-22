class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :titulo
      t.text :corpo
      t.datetime :data

      t.timestamps null: false
    end
  end
end
