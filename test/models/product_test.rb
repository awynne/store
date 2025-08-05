require "test_helper"

class ProductTest < ActiveSupport::TestCase
  def setup
    @valid_product = Product.new(
      name: "Test Shirt",
      price: 29.99,
      category: "shirts",
      description: "A test shirt description"
    )
  end

  # Validation tests
  test "should be valid with valid attributes" do
    assert @valid_product.valid?
  end

  test "should require name" do
    @valid_product.name = nil
    assert_not @valid_product.valid?
    assert_includes @valid_product.errors[:name], "can't be blank"
  end

  test "should require price" do
    @valid_product.price = nil
    assert_not @valid_product.valid?
    assert_includes @valid_product.errors[:price], "can't be blank"
  end

  test "should require price to be greater than 0" do
    @valid_product.price = 0
    assert_not @valid_product.valid?
    assert_includes @valid_product.errors[:price], "must be greater than 0"

    @valid_product.price = -10
    assert_not @valid_product.valid?
    assert_includes @valid_product.errors[:price], "must be greater than 0"
  end

  test "should require category" do
    @valid_product.category = nil
    assert_not @valid_product.valid?
    assert_includes @valid_product.errors[:category], "can't be blank"
  end

  test "should only allow valid categories" do
    Product::CATEGORIES.each do |category|
      @valid_product.category = category
      assert @valid_product.valid?, "#{category} should be valid"
    end

    @valid_product.category = "invalid_category"
    assert_not @valid_product.valid?
    assert_includes @valid_product.errors[:category], "is not included in the list"
  end

  # Business logic tests
  test "formatted_price should return formatted currency" do
    product = Product.new(price: 29.99)
    assert_equal "$29.99", product.formatted_price

    product.price = 100
    assert_equal "$100.00", product.formatted_price

    product.price = 5.5
    assert_equal "$5.50", product.formatted_price
  end

  test "formatted_price should handle nil price" do
    product = Product.new(price: nil)
    assert_equal "$0.00", product.formatted_price
  end

  test "categories class method should return all categories" do
    assert_equal %w[shirts socks jackets shoes], Product.categories
  end

  # Scope tests
  test "by_category scope should filter by category" do
    shirt = products(:shirt)
    sock = products(:sock)

    shirts = Product.by_category("shirts")
    assert_includes shirts, shirt
    assert_not_includes shirts, sock

    socks = Product.by_category("socks")
    assert_includes socks, sock
    assert_not_includes socks, shirt
  end

  test "by_category scope should return all products when category is nil" do
    all_products = Product.by_category(nil)
    assert_equal Product.all.to_a, all_products.to_a
  end

  test "by_category scope should return all products when category is empty" do
    all_products = Product.by_category("")
    assert_equal Product.all.to_a, all_products.to_a
  end
end
