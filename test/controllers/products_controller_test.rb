require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  # Index action tests
  test "should get index" do
    get products_url
    assert_response :success
  end

  test "index should display all products by default" do
    get products_url
    assert_response :success

    # Check that all fixture products are displayed
    assert_select "h3", count: 4 # We have 4 products in fixtures
    assert_select "h3", text: /Test Shirt/
    assert_select "h3", text: /Test Socks/
    assert_select "h3", text: /Test Jacket/
    assert_select "h3", text: /Test Shoes/
  end

  test "index should filter products by category" do
    get products_url(category: "shirts")
    assert_response :success

    # Should only show shirts
    assert_select "h3", count: 1
    assert_select "h3", text: /Test Shirt/

    # Should not show other categories
    assert_select "h3", text: /Test Socks/, count: 0
  end

  test "index should handle invalid category gracefully" do
    get products_url(category: "invalid")
    assert_response :success

    # Should show no products for invalid category
    assert_select "h3", count: 0
  end

  test "index should assign instance variables" do
    get products_url(category: "shirts")
    assert_response :success

    assert_not_nil assigns(:products)
    assert_not_nil assigns(:categories)
    assert_not_nil assigns(:selected_category)
    assert_equal "shirts", assigns(:selected_category)
    assert_equal Product.categories, assigns(:categories)
  end

  test "index should show category filters" do
    get products_url
    assert_response :success

    # Check for filter links
    assert_select "a", text: "All Products"
    assert_select "a", text: "Shirts"
    assert_select "a", text: "Socks"
    assert_select "a", text: "Jackets"
    assert_select "a", text: "Shoes"
  end

  test "index should highlight active category filter" do
    get products_url(category: "shirts")
    assert_response :success

    # Check for active class on shirts filter
    assert_select "a.filter-link.active", text: "Shirts"
  end

  # Show action tests
  test "should get show" do
    product = products(:shirt)
    get product_url(product)
    assert_response :success
  end

  test "show should display product details" do
    product = products(:shirt)
    get product_url(product)
    assert_response :success

    assert_select "h1", text: product.name
    assert_match product.description, response.body
    assert_match product.formatted_price, response.body
    assert_match product.category, response.body
  end

  test "show should handle non-existent product" do
    begin
      get product_url(999999)
      # If no exception is raised, expect a 404 or error response
      assert_response :not_found
    rescue ActiveRecord::RecordNotFound
      # This is the expected behavior in test mode
      assert true
    end
  end

  test "show should assign product instance variable" do
    product = products(:shirt)
    get product_url(product)
    assert_response :success

    assert_not_nil assigns(:product)
    assert_equal product, assigns(:product)
  end

  # Root route test
  test "root should redirect to products index" do
    get root_url
    assert_response :success

    # Should render products index content
    assert_select "h1", text: "Products"
  end
end
