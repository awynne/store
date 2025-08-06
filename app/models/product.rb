class Product < ApplicationRecord
  CATEGORIES = %w[shirts socks jackets shoes].freeze

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :category, presence: true, inclusion: { in: CATEGORIES }
  validates :photo, presence: true

  scope :by_category, ->(category) { where(category: category) if category.present? }

  def formatted_price
    return "$0.00" if price.nil?
    "$#{'%.2f' % price}"
  end

  def self.categories
    CATEGORIES
  end
end
