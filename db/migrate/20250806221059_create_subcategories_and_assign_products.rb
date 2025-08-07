class CreateSubcategoriesAndAssignProducts < ActiveRecord::Migration[8.0]
  def up
    # Create subcategories for each category
    subcategories_data = {
      'Clothing' => [ 'Shirts', 'Pants', 'Shoes', 'Accessories' ],
      'Electronics' => [ 'Audio', 'Mobile Accessories', 'Computing', 'Cables & Adapters' ],
      'Books' => [ 'Technology', 'Photography', 'Cooking', 'Gardening' ],
      'Home' => [ 'Kitchen', 'Lighting', 'Decor', 'Furniture' ],
      'Garden' => [ 'Plants & Seeds', 'Tools', 'Watering', 'Fertilizers' ]
    }

    subcategories_data.each do |category_name, subcategory_names|
      category = Category.find_by(name: category_name)
      next unless category # Skip if category doesn't exist

      subcategory_names.each do |subcategory_name|
        Subcategory.find_or_create_by!(name: subcategory_name, category: category)
      end
    end

    # Assign products to subcategories based on product names
    product_assignments = {
      # Clothing
      'Classic White T-Shirt' => 'Shirts',
      'Denim Button-Up Shirt' => 'Shirts',
      'Polo Shirt' => 'Shirts',
      'Cotton Crew Socks' => 'Accessories',
      'Wool Hiking Socks' => 'Accessories',
      'Athletic Running Socks' => 'Accessories',
      'Leather Bomber Jacket' => 'Shirts',
      'Waterproof Rain Jacket' => 'Shirts',
      'Fleece Zip-Up Hoodie' => 'Shirts',
      'Canvas Sneakers' => 'Shoes',
      'Leather Dress Shoes' => 'Shoes',
      'Running Shoes' => 'Shoes',

      # Electronics
      'Wireless Bluetooth Headphones' => 'Audio',
      'Smartphone Charging Cable' => 'Cables & Adapters',
      'Portable Power Bank' => 'Mobile Accessories',
      'Wireless Mouse' => 'Computing',

      # Books
      'The Art of Programming' => 'Technology',
      'Digital Photography Handbook' => 'Photography',
      'Cooking Essentials' => 'Cooking',
      'Gardening for Beginners' => 'Gardening',

      # Home
      'Ceramic Coffee Mug Set' => 'Kitchen',
      'Throw Pillow Cover Set' => 'Decor',
      'LED Table Lamp' => 'Lighting',
      'Kitchen Utensil Set' => 'Kitchen',

      # Garden
      'Herb Garden Starter Kit' => 'Plants & Seeds',
      'Watering Can' => 'Watering',
      'Garden Tool Set' => 'Tools',
      'Plant Fertilizer' => 'Fertilizers'
    }

    product_assignments.each do |product_name, subcategory_name|
      product = Product.find_by(name: product_name)
      subcategory = Subcategory.joins(:category).find_by(name: subcategory_name)
      if product && subcategory
        product.update!(subcategory: subcategory)
      end
    end
  end

  def down
    Product.update_all(subcategory_id: nil)
    Subcategory.destroy_all
  end
end
