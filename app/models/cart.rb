class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  def total_price
    cart_items.sum { |item| item.subtotal }
  end

  def item_count
    cart_items.sum(:quantity)
  end

  def add_product(product, quantity = 1)
    existing_item = cart_items.find_by(product: product)
    if existing_item
      existing_item.update(quantity: existing_item.quantity + quantity)
    else
      cart_items.create(product: product, quantity: quantity)
    end
  end

  def remove_product(product)
    cart_items.find_by(product: product)&.destroy
  end

  def update_quantity(product, quantity)
    item = cart_items.find_by(product: product)
    if item && quantity > 0
      item.update(quantity: quantity)
    elsif item
      item.destroy
    end
  end

  def clear
    cart_items.destroy_all
  end
end
