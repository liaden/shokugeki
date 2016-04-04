class Recipe < ActiveRecord::Base
  has_many :recipe_ingredients, autosave: true
  has_many :ingredients, through: :recipe_ingredients

  validates :name, presence: true
  validates :url, presence: true, allow_blank: false

  def ingredients_csv
    ingredients.map(&:name).join(',')
  end

  def ingredients_csv=(values)
    RecordIngredients.run!(recipe: self, ingredients: values.split(',').map(&:strip))
  end
end
