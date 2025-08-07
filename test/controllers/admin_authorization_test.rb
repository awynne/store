require "test_helper"

class AdminAuthorizationTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  def setup
    @admin_user = users(:admin)
    @regular_user = users(:regular)
    @product = products(:shirt)
  end

  test "admin can access new product page" do
    sign_in @admin_user
    get new_product_path
    assert_response :success
  end

  test "regular user cannot access new product page" do
    sign_in @regular_user
    get new_product_path
    assert_redirected_to root_path
    assert_equal "Access denied. Admin privileges required.", flash[:alert]
  end

  test "guest user cannot access new product page" do
    get new_product_path
    assert_redirected_to root_path
    assert_equal "Access denied. Admin privileges required.", flash[:alert]
  end

  test "admin can create product" do
    sign_in @admin_user
    assert_difference "Product.count", 1 do
      post products_path, params: {
        product: {
          name: "Test Product",
          category_id: categories(:clothing).id,
          subcategory_id: subcategories(:shirts).id,
          price: 29.99,
          description: "Test description",
          photo: "https://example.com/test.jpg"
        }
      }
    end
    assert_redirected_to product_path(Product.last)
    assert_equal "Product was successfully created.", flash[:notice]
  end

  test "regular user cannot create product" do
    sign_in @regular_user
    assert_no_difference "Product.count" do
      post products_path, params: {
        product: {
          name: "Test Product",
          category_id: categories(:clothing).id,
          price: 29.99
        }
      }
    end
    assert_redirected_to root_path
    assert_equal "Access denied. Admin privileges required.", flash[:alert]
  end

  test "admin can access edit product page" do
    sign_in @admin_user
    get edit_product_path(@product)
    assert_response :success
  end

  test "regular user cannot access edit product page" do
    sign_in @regular_user
    get edit_product_path(@product)
    assert_redirected_to root_path
    assert_equal "Access denied. Admin privileges required.", flash[:alert]
  end

  test "admin can update product" do
    sign_in @admin_user
    patch product_path(@product), params: {
      product: { name: "Updated Product Name" }
    }
    assert_redirected_to product_path(@product)
    assert_equal "Product was successfully updated.", flash[:notice]
    @product.reload
    assert_equal "Updated Product Name", @product.name
  end

  test "regular user cannot update product" do
    sign_in @regular_user
    original_name = @product.name
    patch product_path(@product), params: {
      product: { name: "Hacked Name" }
    }
    assert_redirected_to root_path
    assert_equal "Access denied. Admin privileges required.", flash[:alert]
    @product.reload
    assert_equal original_name, @product.name
  end

  test "admin can delete product" do
    sign_in @admin_user
    assert_difference "Product.count", -1 do
      delete product_path(@product)
    end
    assert_redirected_to products_path
    assert_equal "Product was successfully deleted.", flash[:notice]
  end

  test "regular user cannot delete product" do
    sign_in @regular_user
    assert_no_difference "Product.count" do
      delete product_path(@product)
    end
    assert_redirected_to root_path
    assert_equal "Access denied. Admin privileges required.", flash[:alert]
  end

  test "anyone can view product index" do
    get products_path
    assert_response :success
  end

  test "anyone can view product show page" do
    get product_path(@product)
    assert_response :success
  end

  test "admin actions are visible to admin users in product index" do
    sign_in @admin_user
    get products_path
    assert_response :success
    assert_select "a[href=?]", new_product_path, text: "New Product"
    assert_select "a[href=?]", edit_product_path(@product), text: "Edit"
    assert_select "a[href=?]", product_path(@product), text: "Delete"
  end

  test "admin actions are not visible to regular users in product index" do
    sign_in @regular_user
    get products_path
    assert_response :success
    assert_select "a[href=?]", new_product_path, count: 0
    assert_select "a", text: "Edit", count: 0
    assert_select "a", text: "Delete", count: 0
  end

  test "admin actions are not visible to guests in product index" do
    get products_path
    assert_response :success
    assert_select "a[href=?]", new_product_path, count: 0
    assert_select "a", text: "Edit", count: 0
    assert_select "a", text: "Delete", count: 0
  end

  test "admin actions are visible to admin users in product show page" do
    sign_in @admin_user
    get product_path(@product)
    assert_response :success
    assert_select "a[href=?]", edit_product_path(@product), text: "Edit Product"
    assert_select "a[href=?]", product_path(@product), text: "Delete Product"
  end

  test "admin actions are not visible to regular users in product show page" do
    sign_in @regular_user
    get product_path(@product)
    assert_response :success
    assert_select "a", text: "Edit Product", count: 0
    assert_select "a", text: "Delete Product", count: 0
  end

  test "admin actions are not visible to guests in product show page" do
    get product_path(@product)
    assert_response :success
    assert_select "a", text: "Edit Product", count: 0
    assert_select "a", text: "Delete Product", count: 0
  end
end
