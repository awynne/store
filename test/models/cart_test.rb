require "test_helper"

class CartTest < ActiveSupport::TestCase
  def setup
    @user = users(:admin)
    @cart = @user.create_cart
    @category = Category.create!(name: "Test Category")
    @product = Product.create!(name: "Test Product", price: 19.99, category: @category, photo: "http://example.com/photo.jpg")
  end

  test "should belong to user" do
    assert_respond_to @cart, :user
    assert_equal @user, @cart.user
  end

  test "should have many cart items" do
    assert_respond_to @cart, :cart_items
  end

  test "should have many products through cart items" do
    assert_respond_to @cart, :products
  end

  test "should calculate total price" do
    product2 = Product.create!(name: "Test Product 2", price: 25.99, category: @category, photo: "http://example.com/photo2.jpg")
    item1 = @cart.cart_items.create(product: @product, quantity: 2)
    item2 = @cart.cart_items.create(product: product2, quantity: 1)

    expected_total = (@product.price * 2) + product2.price
    assert_equal expected_total, @cart.total_price
  end

  test "should calculate item count" do
    product2 = Product.create!(name: "Test Product 2", price: 25.99, category: @category, photo: "http://example.com/photo2.jpg")
    @cart.cart_items.create(product: @product, quantity: 2)
    @cart.cart_items.create(product: product2, quantity: 3)

    assert_equal 5, @cart.item_count
  end

  test "should add product to cart" do
    initial_count = @cart.cart_items.count
    @cart.add_product(@product, 2)

    assert_equal initial_count + 1, @cart.cart_items.count
    cart_item = @cart.cart_items.find_by(product: @product)
    assert_equal 2, cart_item.quantity
  end

  test "should increment quantity when adding existing product" do
    @cart.cart_items.create(product: @product, quantity: 1)
    @cart.add_product(@product, 2)

    cart_item = @cart.cart_items.find_by(product: @product)
    assert_equal 3, cart_item.quantity
  end

  test "should remove product from cart" do
    @cart.cart_items.create(product: @product, quantity: 2)
    @cart.remove_product(@product)

    assert_nil @cart.cart_items.find_by(product: @product)
  end

  test "should update product quantity" do
    cart_item = @cart.cart_items.create(product: @product, quantity: 1)
    @cart.update_quantity(@product, 5)

    cart_item.reload
    assert_equal 5, cart_item.quantity
  end

  test "should remove item when updating quantity to zero" do
    @cart.cart_items.create(product: @product, quantity: 1)
    @cart.update_quantity(@product, 0)

    assert_nil @cart.cart_items.find_by(product: @product)
  end

  test "should clear all items" do
    product2 = Product.create!(name: "Test Product 2", price: 25.99, category: @category, photo: "http://example.com/photo2.jpg")
    @cart.cart_items.create(product: @product, quantity: 1)
    @cart.cart_items.create(product: product2, quantity: 2)

    @cart.clear
    assert_equal 0, @cart.cart_items.count
  end
end
