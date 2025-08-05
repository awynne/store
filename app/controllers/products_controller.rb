class ProductsController < ApplicationController
  def index
    @products = Product.by_category(params[:category])
    @categories = Product.categories
    @selected_category = params[:category]
  end

  def show
    @product = Product.find(params[:id])
  end
end
