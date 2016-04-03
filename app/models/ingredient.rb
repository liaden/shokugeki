class Ingredient < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]
  
  has_many :recipes

  validates :name, presence: true
end
