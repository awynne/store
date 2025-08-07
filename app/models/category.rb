class Category < ApplicationRecord
  has_many :products, dependent: :destroy
  has_many :subcategories, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
