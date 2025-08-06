class MigrateProductCategories < ActiveRecord::Migration[8.0]
  def up
    # Create categories based on existing product categories
    categories = {
      'shirts' => 'Clothing',
      'socks' => 'Clothing',
      'jackets' => 'Clothing',
      'shoes' => 'Clothing'
    }

    categories.values.uniq.each do |category_name|
      Category.find_or_create_by!(name: category_name)
    end

    # Update existing products to use new category associations
    categories.each do |old_category, new_category|
      clothing_category = Category.find_by!(name: new_category)
      Product.where(category: old_category).update_all(category_id: clothing_category.id)
    end
  end

  def down
    # Remove category associations but keep old category strings
    Product.update_all(category_id: nil)
    Category.destroy_all
  end
end
