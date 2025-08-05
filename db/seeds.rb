# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

products = [
  # Shirts
  { name: "Classic White T-Shirt", category: "shirts", price: 19.99, description: "A comfortable cotton t-shirt perfect for everyday wear." },
  { name: "Denim Button-Up Shirt", category: "shirts", price: 49.99, description: "Classic denim shirt with a modern fit and durable construction." },
  { name: "Polo Shirt", category: "shirts", price: 34.99, description: "Elegant polo shirt made from premium cotton blend." },
  
  # Socks
  { name: "Cotton Crew Socks", category: "socks", price: 12.99, description: "Soft and breathable crew socks for everyday comfort." },
  { name: "Wool Hiking Socks", category: "socks", price: 18.99, description: "Durable merino wool socks perfect for outdoor activities." },
  { name: "Athletic Running Socks", category: "socks", price: 15.99, description: "Moisture-wicking socks designed for athletic performance." },
  
  # Jackets
  { name: "Leather Bomber Jacket", category: "jackets", price: 199.99, description: "Premium leather bomber jacket with classic styling." },
  { name: "Waterproof Rain Jacket", category: "jackets", price: 89.99, description: "Lightweight and breathable rain jacket for outdoor adventures." },
  { name: "Fleece Zip-Up Hoodie", category: "jackets", price: 59.99, description: "Cozy fleece hoodie perfect for casual wear and layering." },
  
  # Shoes
  { name: "Canvas Sneakers", category: "shoes", price: 79.99, description: "Classic canvas sneakers with rubber sole and comfortable fit." },
  { name: "Leather Dress Shoes", category: "shoes", price: 149.99, description: "Elegant leather oxfords perfect for formal occasions." },
  { name: "Running Shoes", category: "shoes", price: 119.99, description: "High-performance running shoes with advanced cushioning technology." }
]

products.each do |product_attrs|
  Product.find_or_create_by(name: product_attrs[:name]) do |product|
    product.category = product_attrs[:category]
    product.price = product_attrs[:price]
    product.description = product_attrs[:description]
  end
end
