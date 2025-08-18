class Product < ApplicationRecord
  include Sluggable
  has_many :sales, dependent: :destroy
end
