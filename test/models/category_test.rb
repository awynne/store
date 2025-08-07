require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  def setup
    @category = Category.new(name: "Test Category")
  end

  test "should be valid with valid attributes" do
    assert @category.valid?
  end

  test "should require name" do
    @category.name = nil
    assert_not @category.valid?
    assert_includes @category.errors[:name], "can't be blank"
  end

  test "should require unique name" do
    Category.create!(name: "Duplicate Name")
    @category.name = "Duplicate Name"
    assert_not @category.valid?
    assert_includes @category.errors[:name], "has already been taken"
  end

  test "should have many products" do
    category = categories(:clothing)
    assert_respond_to category, :products
    assert category.products.count >= 1
  end
end
