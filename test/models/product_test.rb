require "test_helper"

class ProductTest < ActiveSupport::TestCase
  def setup
    @category = categories(:clothing)
    @valid_product = Product.new(
      name: "Test Shirt",
      price: 29.99,
      category: @category,
      description: "A test shirt description",
      photo: "https://example.com/test-photo.jpg"
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

  test "should belong to category" do
    assert_instance_of Category, @valid_product.category
    assert_equal @category.name, @valid_product.category.name
  end

  test "should require photo" do
    @valid_product.photo = nil
    assert_not @valid_product.valid?
    assert_includes @valid_product.errors[:photo], "can't be blank"

    @valid_product.photo = ""
    assert_not @valid_product.valid?
    assert_includes @valid_product.errors[:photo], "can't be blank"
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

  test "categories class method should return all category names" do
    # This will return the category names from the database
    categories = Product.categories
    assert_includes categories, "Clothing"
    assert_includes categories, "Electronics"
  end

  # Scope tests
  test "by_category scope should filter by category" do
    shirt = products(:shirt)
    sock = products(:sock)

    clothing_products = Product.by_category("Clothing")
    assert_includes clothing_products, shirt
    assert_includes clothing_products, sock
  end

  test "by_category scope should return all products when category is nil" do
    all_products = Product.by_category(nil)
    assert_equal Product.all.to_a, all_products.to_a
  end

  test "by_category scope should return all products when category is empty" do
    all_products = Product.by_category("")
    assert_equal Product.all.to_a, all_products.to_a
  end

  test "by_subcategory scope should filter by subcategory" do
    shirt = products(:shirt)
    sock = products(:sock)

    shirts_products = Product.by_subcategory("Shirts")
    assert_includes shirts_products, shirt
    assert_includes shirts_products, sock
  end

  test "by_subcategory scope should return all products when subcategory is nil" do
    all_products = Product.by_subcategory(nil)
    assert_equal Product.all.to_a, all_products.to_a
  end

  test "by_subcategory scope should return all products when subcategory is empty" do
    all_products = Product.by_subcategory("")
    assert_equal Product.all.to_a, all_products.to_a
  end

  test "should belong to subcategory" do
    subcategory = subcategories(:shirts)
    @valid_product.subcategory = subcategory
    assert_equal subcategory, @valid_product.subcategory
  end
end
