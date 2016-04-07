class Ingredient < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  has_many :recipe_ingredients
  has_many :recipes, through: :recipe_ingredients

  def ingredient_pairings
    IngredientPairing.with_ingredient(self)
  end

  def pairings(ordering: 'created_at')
    ingredient_pairings
      .includes(:first_ingredient, :second_ingredient)
      .order(ordering)
      .map do |pair|
        pair.first_ingredient.id == id ? pair.second_ingredient : pair.first_ingredient
      end
  end

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

  def self.mass_produce(*names)
    names.map { |name| Ingredient.find_or_create_by(name: name) }
  end

  def recipes_count
    recipe_ingredients_count
  end

  private

  has_many :first_ingredients,  through: :ingredient_pairings
  has_many :second_ingredients, through: :ingredient_pairings

  has_many :pairings
end
