# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create categories first
categories = %w[Clothing Electronics Books Home Garden]
categories.each do |category_name|
  Category.find_or_create_by(name: category_name)
end

# Create subcategories
subcategories_data = {
  'Clothing' => [ 'Shirts', 'Pants', 'Shoes', 'Accessories' ],
  'Electronics' => [ 'Audio', 'Mobile Accessories', 'Computing', 'Cables & Adapters' ],
  'Books' => [ 'Technology', 'Photography', 'Cooking', 'Gardening' ],
  'Home' => [ 'Kitchen', 'Lighting', 'Decor', 'Furniture' ],
  'Garden' => [ 'Plants & Seeds', 'Tools', 'Watering', 'Fertilizers' ]
}

subcategories_data.each do |category_name, subcategory_names|
  category = Category.find_by!(name: category_name)
  subcategory_names.each do |subcategory_name|
    Subcategory.find_or_create_by(name: subcategory_name, category: category)
  end
end

# Get category and subcategory references
clothing = Category.find_by!(name: 'Clothing')
electronics = Category.find_by!(name: 'Electronics')
books = Category.find_by!(name: 'Books')
home = Category.find_by!(name: 'Home')
garden = Category.find_by!(name: 'Garden')

# Get subcategory references
shirts_subcat = Subcategory.find_by!(name: 'Shirts', category: clothing)
accessories_subcat = Subcategory.find_by!(name: 'Accessories', category: clothing)
shoes_subcat = Subcategory.find_by!(name: 'Shoes', category: clothing)
audio_subcat = Subcategory.find_by!(name: 'Audio', category: electronics)
cables_subcat = Subcategory.find_by!(name: 'Cables & Adapters', category: electronics)
mobile_subcat = Subcategory.find_by!(name: 'Mobile Accessories', category: electronics)
computing_subcat = Subcategory.find_by!(name: 'Computing', category: electronics)
technology_subcat = Subcategory.find_by!(name: 'Technology', category: books)
photography_subcat = Subcategory.find_by!(name: 'Photography', category: books)
cooking_subcat = Subcategory.find_by!(name: 'Cooking', category: books)
gardening_books_subcat = Subcategory.find_by!(name: 'Gardening', category: books)
kitchen_subcat = Subcategory.find_by!(name: 'Kitchen', category: home)
lighting_subcat = Subcategory.find_by!(name: 'Lighting', category: home)
decor_subcat = Subcategory.find_by!(name: 'Decor', category: home)
plants_subcat = Subcategory.find_by!(name: 'Plants & Seeds', category: garden)
tools_subcat = Subcategory.find_by!(name: 'Tools', category: garden)
watering_subcat = Subcategory.find_by!(name: 'Watering', category: garden)
fertilizers_subcat = Subcategory.find_by!(name: 'Fertilizers', category: garden)

products = [
  # Clothing
  { name: "Classic White T-Shirt", category: clothing, subcategory: shirts_subcat, price: 19.99, description: "A comfortable cotton t-shirt perfect for everyday wear.", photo: "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400&h=400&fit=crop" },
  { name: "Denim Button-Up Shirt", category: clothing, subcategory: shirts_subcat, price: 49.99, description: "Classic denim shirt with a modern fit and durable construction.", photo: "https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=400&h=400&fit=crop" },
  { name: "Polo Shirt", category: clothing, subcategory: shirts_subcat, price: 34.99, description: "Elegant polo shirt made from premium cotton blend.", photo: "https://images.unsplash.com/photo-1586790170083-2f9ceadc732d?w=400&h=400&fit=crop" },
  { name: "Cotton Crew Socks", category: clothing, subcategory: accessories_subcat, price: 12.99, description: "Soft and breathable crew socks for everyday comfort.", photo: "https://images.unsplash.com/photo-1586350977771-b3b0abd50c82?w=400&h=400&fit=crop" },
  { name: "Wool Hiking Socks", category: clothing, subcategory: accessories_subcat, price: 18.99, description: "Durable merino wool socks perfect for outdoor activities.", photo: "https://images.unsplash.com/photo-1544966503-7cc5ac882d5f?w=400&h=400&fit=crop" },
  { name: "Athletic Running Socks", category: clothing, subcategory: accessories_subcat, price: 15.99, description: "Moisture-wicking socks designed for athletic performance.", photo: "https://images.unsplash.com/photo-1556906781-9a412961c28c?w=400&h=400&fit=crop" },
  { name: "Leather Bomber Jacket", category: clothing, subcategory: shirts_subcat, price: 199.99, description: "Premium leather bomber jacket with classic styling.", photo: "https://images.unsplash.com/photo-1551537482-f2075a1d41f2?w=400&h=400&fit=crop" },
  { name: "Waterproof Rain Jacket", category: clothing, subcategory: shirts_subcat, price: 89.99, description: "Lightweight and breathable rain jacket for outdoor adventures.", photo: "https://images.unsplash.com/photo-1544966503-7cc5ac882d5f?w=400&h=400&fit=crop&auto=format" },
  { name: "Fleece Zip-Up Hoodie", category: clothing, subcategory: shirts_subcat, price: 59.99, description: "Cozy fleece hoodie perfect for casual wear and layering.", photo: "https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400&h=400&fit=crop&auto=format" },
  { name: "Canvas Sneakers", category: clothing, subcategory: shoes_subcat, price: 79.99, description: "Classic canvas sneakers with rubber sole and comfortable fit.", photo: "https://images.unsplash.com/photo-1549298916-b41d501d3772?w=400&h=400&fit=crop" },
  { name: "Leather Dress Shoes", category: clothing, subcategory: shoes_subcat, price: 149.99, description: "Elegant leather oxfords perfect for formal occasions.", photo: "https://images.unsplash.com/photo-1582897085656-c636d006a246?w=400&h=400&fit=crop" },
  { name: "Running Shoes", category: clothing, subcategory: shoes_subcat, price: 119.99, description: "High-performance running shoes with advanced cushioning technology.", photo: "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&h=400&fit=crop" },

  # Electronics
  { name: "Wireless Bluetooth Headphones", category: electronics, subcategory: audio_subcat, price: 89.99, description: "Premium noise-canceling wireless headphones with 30-hour battery life.", photo: "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400&h=400&fit=crop" },
  { name: "Smartphone Charging Cable", category: electronics, subcategory: cables_subcat, price: 24.99, description: "Fast-charging USB-C cable compatible with most modern devices.", photo: "https://images.unsplash.com/photo-1583394838336-acd977736f90?w=400&h=400&fit=crop" },
  { name: "Portable Power Bank", category: electronics, subcategory: mobile_subcat, price: 39.99, description: "10,000mAh portable charger with dual USB ports and LED display.", photo: "https://images.unsplash.com/photo-1609692814967-0b4feac5ec40?w=400&h=400&fit=crop" },
  { name: "Wireless Mouse", category: electronics, subcategory: computing_subcat, price: 29.99, description: "Ergonomic wireless optical mouse with precision tracking.", photo: "https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?w=400&h=400&fit=crop" },

  # Books
  { name: "The Art of Programming", category: books, subcategory: technology_subcat, price: 45.99, description: "Comprehensive guide to software development best practices and design patterns.", photo: "https://images.unsplash.com/photo-1532012197267-da84d127e765?w=400&h=400&fit=crop" },
  { name: "Digital Photography Handbook", category: books, subcategory: photography_subcat, price: 32.99, description: "Master the fundamentals of digital photography from beginner to advanced techniques.", photo: "https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400&h=400&fit=crop" },
  { name: "Cooking Essentials", category: books, subcategory: cooking_subcat, price: 28.99, description: "A complete cookbook with over 200 recipes for home cooks of all skill levels.", photo: "https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400&h=400&fit=crop" },
  { name: "Gardening for Beginners", category: books, subcategory: gardening_books_subcat, price: 24.99, description: "Learn how to grow your own vegetables, herbs, and flowers at home.", photo: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&h=400&fit=crop" },

  # Home
  { name: "Ceramic Coffee Mug Set", category: home, subcategory: kitchen_subcat, price: 34.99, description: "Set of 4 handcrafted ceramic mugs perfect for coffee, tea, or hot chocolate.", photo: "https://images.unsplash.com/photo-1514228742587-6b1558fcf93a?w=400&h=400&fit=crop" },
  { name: "Throw Pillow Cover Set", category: home, subcategory: decor_subcat, price: 22.99, description: "Set of 2 decorative pillow covers made from premium cotton blend fabric.", photo: "https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=400&h=400&fit=crop" },
  { name: "LED Table Lamp", category: home, subcategory: lighting_subcat, price: 56.99, description: "Modern minimalist LED desk lamp with adjustable brightness and USB charging port.", photo: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop" },
  { name: "Kitchen Utensil Set", category: home, subcategory: kitchen_subcat, price: 42.99, description: "Complete 12-piece silicone cooking utensil set with wooden handles.", photo: "https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400&h=400&fit=crop" },

  # Garden
  { name: "Herb Garden Starter Kit", category: garden, subcategory: plants_subcat, price: 29.99, description: "Everything you need to start growing basil, oregano, and thyme at home.", photo: "https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=400&h=400&fit=crop" },
  { name: "Watering Can", category: garden, subcategory: watering_subcat, price: 18.99, description: "Durable galvanized steel watering can with long spout for precise watering.", photo: "https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=400&h=400&fit=crop" },
  { name: "Garden Tool Set", category: garden, subcategory: tools_subcat, price: 67.99, description: "Complete 5-piece garden tool set with ergonomic handles and carrying bag.", photo: "https://images.unsplash.com/photo-1523348837708-15d4a09cfac2?w=400&h=400&fit=crop" },
  { name: "Plant Fertilizer", category: garden, subcategory: fertilizers_subcat, price: 15.99, description: "All-purpose organic plant fertilizer for indoor and outdoor plants.", photo: "https://images.unsplash.com/photo-1465146344425-f00d5f5c8f07?w=400&h=400&fit=crop" }
]

products.each do |product_attrs|
  Product.find_or_create_by(name: product_attrs[:name]) do |product|
    product.category = product_attrs[:category]
    product.subcategory = product_attrs[:subcategory]
    product.price = product_attrs[:price]
    product.description = product_attrs[:description]
    product.photo = product_attrs[:photo]
  end
end
