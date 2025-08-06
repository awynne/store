class Product < ApplicationRecord
  belongs_to :category
  belongs_to :subcategory, optional: true

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :category, presence: true
  validates :photo, presence: true

  scope :by_category, ->(category) { joins(:category).where(categories: { name: category }) if category.present? }
  scope :by_subcategory, ->(subcategory) { joins(:subcategory).where(subcategories: { name: subcategory }) if subcategory.present? }

  def formatted_price
    return "$0.00" if price.nil?
    "$#{'%.2f' % price}"
  end

  def self.categories
    Category.pluck(:name)
  end
end
