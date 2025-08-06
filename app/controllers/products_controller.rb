class ProductsController < ApplicationController
  before_action :set_product, only: [ :show, :edit, :update, :destroy ]

  def index
    @products = filter_products
    @categories = Product.categories
    @selected_category = params[:category]
    @selected_subcategory = params[:subcategory]
  end

  def show
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to @product, notice: "Product was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      redirect_to @product, notice: "Product was successfully updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @product.destroy
    redirect_to products_path, notice: "Product was successfully deleted."
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :category_id, :subcategory_id, :price, :description, :photo)
  end

  def filter_products
    products = Product.all

    if params[:subcategory].present?
      products = products.by_subcategory(params[:subcategory])
    elsif params[:category].present?
      products = products.by_category(params[:category])
    end

    products
  end
end
