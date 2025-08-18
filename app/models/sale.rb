class Sale < ApplicationRecord
  belongs_to :product

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  before_save :calculate_total

  private
  def calculate_total
    # Ensure product and quantity are present to avoid errors
    self.total = product.price * quantity if product.present? && quantity.present?
  end
end
