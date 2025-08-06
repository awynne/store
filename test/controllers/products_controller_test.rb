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
    get products_url(category: "Clothing")
    assert_response :success

    # Should show all clothing items (all test products are clothing)
    assert_select "h3", count: 4
    assert_select "h3", text: /Test Shirt/
    assert_select "h3", text: /Test Socks/
  end

  test "index should handle invalid category gracefully" do
    get products_url(category: "invalid")
    assert_response :success

    # Should show no products for invalid category
    assert_select "h3", count: 0
  end

  test "index should assign instance variables" do
    get products_url(category: "Clothing")
    assert_response :success

    assert_not_nil assigns(:products)
    assert_not_nil assigns(:categories)
    assert_not_nil assigns(:selected_category)
    assert_equal "Clothing", assigns(:selected_category)
    assert_equal Product.categories, assigns(:categories)
  end

  test "index should filter products by subcategory" do
    get products_url(category: "Clothing", subcategory: "Shirts")
    assert_response :success

    # Should show all shirts (all test products are in shirts subcategory)
    assert_select "h3", count: 4
    assert_select "h3", text: /Test Shirt/
    assert_select "h3", text: /Test Socks/
  end

  test "index should assign subcategory instance variable" do
    get products_url(category: "Clothing", subcategory: "Shirts")
    assert_response :success

    assert_not_nil assigns(:selected_subcategory)
    assert_equal "Shirts", assigns(:selected_subcategory)
  end

  test "index should show category filters" do
    get products_url
    assert_response :success

    # Check for filter links
    assert_select "a", text: "All Products"
    assert_select "a", text: "Clothing"
    assert_select "a", text: "Electronics"
  end

  test "index should highlight active category filter" do
    get products_url(category: "Clothing")
    assert_response :success

    # Check for active class on clothing filter
    assert_select "a.filter-link.active", text: "Clothing"
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
    assert_match product.category.name, response.body
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

  # New action tests
  test "should get new" do
    get new_product_url
    assert_response :success
  end

  test "new should display product form" do
    get new_product_url
    assert_response :success

    assert_select "form"
    assert_select "input[name='product[name]']"
    assert_select "select[name='product[category_id]']"
    assert_select "select[name='product[subcategory_id]']"
    assert_select "input[name='product[price]']"
    assert_select "input[name='product[photo]']"
    assert_select "textarea[name='product[description]']"
  end

  # Create action tests
  test "should create product" do
    category = categories(:clothing)
    assert_difference("Product.count") do
      post products_url, params: {
        product: {
          name: "New Test Product",
          category_id: category.id,
          price: 25.99,
          description: "A new test product",
          photo: "https://example.com/new-photo.jpg"
        }
      }
    end

    assert_redirected_to product_url(Product.last)
  end

  test "should not create product with invalid data" do
    assert_no_difference("Product.count") do
      post products_url, params: {
        product: {
          name: "",
          category_id: nil,
          price: -10,
          photo: ""
        }
      }
    end

    assert_response :unprocessable_content
  end

  # Edit action tests
  test "should get edit" do
    product = products(:shirt)
    get edit_product_url(product)
    assert_response :success
  end

  test "edit should display product form with current values" do
    product = products(:shirt)
    get edit_product_url(product)
    assert_response :success

    assert_select "form"
    assert_select "input[name='product[name]'][value=?]", product.name
    assert_select "input[name='product[photo]'][value=?]", product.photo
  end

  # Update action tests
  test "should update product" do
    product = products(:shirt)
    patch product_url(product), params: {
      product: {
        name: "Updated Test Shirt",
        photo: "https://example.com/updated-photo.jpg"
      }
    }

    assert_redirected_to product_url(product)
    product.reload
    assert_equal "Updated Test Shirt", product.name
    assert_equal "https://example.com/updated-photo.jpg", product.photo
  end

  test "should not update product with invalid data" do
    product = products(:shirt)
    original_name = product.name

    patch product_url(product), params: {
      product: {
        name: "",
        price: -10
      }
    }

    assert_response :unprocessable_content
    product.reload
    assert_equal original_name, product.name
  end

  # Destroy action tests
  test "should destroy product" do
    product = products(:shirt)
    assert_difference("Product.count", -1) do
      delete product_url(product)
    end

    assert_redirected_to products_url
  end

  # Root route test
  test "root should redirect to products index" do
    get root_url
    assert_response :success

    # Should render products index content
    assert_match "Products", response.body
  end
end
