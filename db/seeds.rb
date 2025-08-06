# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

products = [
  # Shirts
  { name: "Classic White T-Shirt", category: "shirts", price: 19.99, description: "A comfortable cotton t-shirt perfect for everyday wear.", photo: "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400&h=400&fit=crop" },
  { name: "Denim Button-Up Shirt", category: "shirts", price: 49.99, description: "Classic denim shirt with a modern fit and durable construction.", photo: "https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=400&h=400&fit=crop" },
  { name: "Polo Shirt", category: "shirts", price: 34.99, description: "Elegant polo shirt made from premium cotton blend.", photo: "https://images.unsplash.com/photo-1586790170083-2f9ceadc732d?w=400&h=400&fit=crop" },

  # Socks
  { name: "Cotton Crew Socks", category: "socks", price: 12.99, description: "Soft and breathable crew socks for everyday comfort.", photo: "https://images.unsplash.com/photo-1586350977771-b3b0abd50c82?w=400&h=400&fit=crop" },
  { name: "Wool Hiking Socks", category: "socks", price: 18.99, description: "Durable merino wool socks perfect for outdoor activities.", photo: "https://images.unsplash.com/photo-1544966503-7cc5ac882d5f?w=400&h=400&fit=crop" },
  { name: "Athletic Running Socks", category: "socks", price: 15.99, description: "Moisture-wicking socks designed for athletic performance.", photo: "https://images.unsplash.com/photo-1556906781-9a412961c28c?w=400&h=400&fit=crop" },

  # Jackets
  { name: "Leather Bomber Jacket", category: "jackets", price: 199.99, description: "Premium leather bomber jacket with classic styling.", photo: "https://images.unsplash.com/photo-1551537482-f2075a1d41f2?w=400&h=400&fit=crop" },
  { name: "Waterproof Rain Jacket", category: "jackets", price: 89.99, description: "Lightweight and breathable rain jacket for outdoor adventures.", photo: "https://images.unsplash.com/photo-1544966503-7cc5ac882d5f?w=400&h=400&fit=crop&auto=format" },
  { name: "Fleece Zip-Up Hoodie", category: "jackets", price: 59.99, description: "Cozy fleece hoodie perfect for casual wear and layering.", photo: "https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400&h=400&fit=crop&auto=format" },

  # Shoes
  { name: "Canvas Sneakers", category: "shoes", price: 79.99, description: "Classic canvas sneakers with rubber sole and comfortable fit.", photo: "https://images.unsplash.com/photo-1549298916-b41d501d3772?w=400&h=400&fit=crop" },
  { name: "Leather Dress Shoes", category: "shoes", price: 149.99, description: "Elegant leather oxfords perfect for formal occasions.", photo: "https://images.unsplash.com/photo-1582897085656-c636d006a246?w=400&h=400&fit=crop" },
  { name: "Running Shoes", category: "shoes", price: 119.99, description: "High-performance running shoes with advanced cushioning technology.", photo: "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&h=400&fit=crop" }
]

products.each do |product_attrs|
  product = Product.find_or_initialize_by(name: product_attrs[:name])
  product.category = product_attrs[:category]
  product.price = product_attrs[:price]
  product.description = product_attrs[:description]
  product.photo = product_attrs[:photo]
  product.save!
end
