class CartsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart
  before_action :set_product, only: [ :add_item, :remove_item, :update_quantity ]

  def show
  end

  def add_item
    quantity = params[:quantity].to_i
    quantity = 1 if quantity <= 0

    @cart.add_product(@product, quantity)

    respond_to do |format|
      format.html { redirect_to @product, notice: "#{@product.name} added to cart!" }
      format.json { render json: { status: "success", item_count: @cart.item_count, total: @cart.total_price } }
    end
  end

  def remove_item
    @cart.remove_product(@product)

    respond_to do |format|
      format.html { redirect_to cart_path, notice: "#{@product.name} removed from cart!" }
      format.json { render json: { status: "success", item_count: @cart.item_count, total: @cart.total_price } }
    end
  end

  def update_quantity
    quantity = params[:quantity].to_i
    @cart.update_quantity(@product, quantity)

    respond_to do |format|
      format.html { redirect_to cart_path }
      format.json { render json: { status: "success", item_count: @cart.item_count, total: @cart.total_price } }
    end
  end

  def clear
    @cart.clear

    respond_to do |format|
      format.html { redirect_to cart_path, notice: "Cart cleared!" }
      format.json { render json: { status: "success", item_count: 0, total: 0 } }
    end
  end

  private

  def set_cart
    @cart = current_user.current_cart
  end

  def set_product
    @product = Product.find(params[:product_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to products_path, alert: "Product not found!"
  end
end
