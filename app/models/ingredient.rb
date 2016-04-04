class Ingredient < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  has_many :recipe_ingredients
  has_many :recipes, through: :recipe_ingredients

  validates :name, presence: true

  scope :popularity, -> { order('recipe_ingredients_count DESC') }
  scope :rarity, -> { order('recipe_ingredients_count ASC') }
  scope :alphabetical, -> { order('name ASC') }

  def self.sanitized_order(by)
    if [:popularity, :alphabetical, :age].include?(by.try(:to_sym))
      self.send(by)
    else
      alphabetical
    end
  end

  def recipes_count
    recipe_ingredients_count
  end
end