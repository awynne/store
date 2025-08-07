class CreateCarts < ActiveRecord::Migration[8.0]
  def change
    create_table :carts do |t|
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    unless index_exists?(:carts, :user_id)
      add_index :carts, :user_id, unique: true
    end
  end
end
