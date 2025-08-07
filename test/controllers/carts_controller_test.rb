require "test_helper"

class CartsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:admin)
    @category = Category.create!(name: "Test Category")
    @product = Product.create!(name: "Test Product", price: 19.99, category: @category, photo: "http://example.com/photo.jpg")
    @cart = @user.create_cart
    sign_in @user
  end

  test "should require authentication for show" do
    sign_out @user
    get cart_url
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should show cart when authenticated" do
    get cart_url
    assert_response :success
    assert_select "h1", "Your Shopping Cart"
  end

  test "should display empty cart message when no items" do
    get cart_url
    assert_response :success
    assert_select "h2", "Your cart is empty"
  end

  test "should display cart items when items exist" do
    @cart.add_product(@product, 2)
    get cart_url
    assert_response :success
    assert_select "h3", @product.name
  end

  test "should add item to cart" do
    assert_difference "@cart.cart_items.count", 1 do
      post add_item_cart_url, params: { product_id: @product.id, quantity: 2 }
    end
    assert_redirected_to @product
    assert_equal "#{@product.name} added to cart!", flash[:notice]
  end

  test "should add item to cart via ajax" do
    assert_difference "@cart.cart_items.count", 1 do
      post add_item_cart_url, params: { product_id: @product.id, quantity: 2 },
           headers: { "Accept" => "application/json" }
    end
    assert_response :success
    response_data = JSON.parse(response.body)
    assert_equal "success", response_data["status"]
  end

  test "should require authentication for add_item" do
    sign_out @user
    post add_item_cart_url, params: { product_id: @product.id }
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should handle invalid product for add_item" do
    post add_item_cart_url, params: { product_id: 999999 }
    assert_redirected_to products_path
    assert_equal "Product not found!", flash[:alert]
  end

  test "should remove item from cart" do
    @cart.add_product(@product, 2)

    assert_difference "@cart.cart_items.count", -1 do
      delete remove_item_cart_url, params: { product_id: @product.id }
    end
    assert_redirected_to cart_path
    assert_equal "#{@product.name} removed from cart!", flash[:notice]
  end

  test "should remove item from cart via ajax" do
    @cart.add_product(@product, 2)

    assert_difference "@cart.cart_items.count", -1 do
      delete remove_item_cart_url, params: { product_id: @product.id },
             headers: { "Accept" => "application/json" }
    end
    assert_response :success
  end

  test "should update quantity in cart" do
    @cart.add_product(@product, 2)

    patch update_quantity_cart_url, params: { product_id: @product.id, quantity: 5 }
    assert_redirected_to cart_path

    cart_item = @cart.cart_items.find_by(product: @product)
    assert_equal 5, cart_item.quantity
  end

  test "should remove item when updating quantity to zero" do
    @cart.add_product(@product, 2)

    assert_difference "@cart.cart_items.count", -1 do
      patch update_quantity_cart_url, params: { product_id: @product.id, quantity: 0 }
    end
  end

  test "should clear entire cart" do
    product2 = Product.create!(name: "Test Product 2", price: 25.99, category: @category, photo: "http://example.com/photo2.jpg")
    @cart.add_product(@product, 2)
    @cart.add_product(product2, 1)

    assert_difference "@cart.cart_items.count", -2 do
      delete clear_cart_url
    end
    assert_redirected_to cart_path
    assert_equal "Cart cleared!", flash[:notice]
  end

  test "should clear cart via ajax" do
    @cart.add_product(@product, 2)

    delete clear_cart_url, headers: { "Accept" => "application/json" }
    assert_response :success
    response_data = JSON.parse(response.body)
    assert_equal "success", response_data["status"]
    assert_equal 0, response_data["item_count"]
  end
end
