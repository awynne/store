require "test_helper"

class CartItemTest < ActiveSupport::TestCase
  def setup
    @user = users(:admin)
    @cart = @user.create_cart
    @category = Category.create!(name: "Test Category")
    @product = Product.create!(name: "Test Product", price: 19.99, category: @category, photo: "http://example.com/photo.jpg")
    @cart_item = CartItem.create!(cart: @cart, product: @product, quantity: 2)
  end

  test "should belong to cart" do
    assert_respond_to @cart_item, :cart
    assert_equal @cart, @cart_item.cart
  end

  test "should belong to product" do
    assert_respond_to @cart_item, :product
    assert_equal @product, @cart_item.product
  end

  test "should validate presence of quantity" do
    different_product = Product.create!(name: "Different Product", price: 15.99, category: @category, photo: "http://example.com/diff.jpg")
    cart_item = CartItem.new(cart: @cart, product: different_product, quantity: nil)
    assert_not cart_item.valid?
    assert_includes cart_item.errors[:quantity], "can't be blank"
  end

  test "should validate quantity is greater than zero" do
    different_product = Product.create!(name: "Different Product", price: 15.99, category: @category, photo: "http://example.com/diff.jpg")
    cart_item = CartItem.new(cart: @cart, product: different_product, quantity: 0)
    assert_not cart_item.valid?
    assert_includes cart_item.errors[:quantity], "must be greater than 0"
  end

  test "should validate uniqueness of product per cart" do
    duplicate_item = CartItem.new(cart: @cart, product: @product, quantity: 2)

    assert_not duplicate_item.valid?
    assert_includes duplicate_item.errors[:product_id], "has already been taken"
  end

  test "should calculate subtotal" do
    @cart_item.quantity = 3
    expected_subtotal = @cart_item.product.price * 3
    assert_equal expected_subtotal, @cart_item.subtotal
  end

  test "should allow same product in different carts" do
    user2 = users(:regular)
    cart2 = user2.create_cart
    item2 = CartItem.new(cart: cart2, product: @product, quantity: 2)

    assert item2.valid?
  end
end
