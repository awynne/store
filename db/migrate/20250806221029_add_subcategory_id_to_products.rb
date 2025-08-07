class AddSubcategoryIdToProducts < ActiveRecord::Migration[8.0]
  def change
    add_reference :products, :subcategory, null: true, foreign_key: true
  end
end
