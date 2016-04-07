Rails.logger.debug "Loading schema"
[
  Recipe.create!(
    name: 'Roast Chicken with Spring Vegetables',
    url: 'http://www.foodnetwork.com/recipes/food-network-kitchens/roast-chicken-with-spring-vegetables-recipe.html',
    ingredients:
      Ingredient.mass_produce(
        'chicken',
        'salt',
        'lemon',
        'olive oil',
        'potato',
        'radish',
        'dill',
        'carrot'
      )
  ),
  Recipe.create!(
    name: 'Pan-Seared Salmon with Kale and Apple Salad',
    url: 'http://www.foodnetwork.com/recipes/food-network-kitchens/pan-seared-salmon-with-kale-and-apple-salad-recipe.html',
    ingredients:
      Ingredient.mass_produce(
        'salmon',
        'lemon juice',
        'olive oil',
        'salt',
        'kale',
        'dates',
        'honeycrisp apple',
        'pecorino',
        'almonds',
        'black pepper'
      )
  ),
  Recipe.create!(
    name: 'Lemon-Garlic Shrimp and Grits',
    url: 'http://www.foodnetwork.com/recipes/food-network-kitchens/lemon-garlic-shrimp-and-grits-recipe.html',
    ingredients:
      Ingredient.mass_produce(
        'lemon',
        'grits',
        'black pepper',
        'salt',
        'butter',
        'shrimp',
        'garlic',
        'cayenne pepper',
        'parsley'
      ),
  ),
  Recipe.create!(
    name: 'Vegetable Meatloaf with Balsamic Glaze',
    url: 'http://www.foodnetwork.com/recipes/bobby-flay/vegetable-meatloaf-with-balsamic-glaze-recipe.html',
    ingredients:
      Ingredient.mass_produce(
        'olive oil',
        'zucchini',
        'red bell pepper',
        'yellow bell peper',
        'garlic',
        'red pepper flakes',
        'salt',
        'pepper',
        'egg',
        'thyme',
        'parsley',
        'turkey',
        'breadcrumbs',
        'parmesan cheese',
        'ketchup',
        'balsamic vinegar'
      )
  )
].each do |recipe|
  RecordPairings.run!(recipe: recipe)
end
Rails.logger.debug "Finished loading schema"
