class AddCategoryToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :category, :string
    add_column :products, :price, :decimal, precision: 8, scale: 2
    add_column :products, :description, :text
  end
end
