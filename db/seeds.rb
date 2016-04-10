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
  ),
  Recipe.create!(
    name: 'Rhubarb Crumble',
    url: 'http://www.foodnetwork.com/recipes/food-network-kitchens/rhubarb-crumble-recipe.html',
    ingredients:
      Ingredient.mass_produce(
        'flour',
        'oats',
        'sugar',
        'butter',
        'hazelnuts',
        'rhubarb',
        'vanilla extract',
        'orange zest',
        'salt'
      )
  ),
  Recipe.create!(
    name: 'Quick, Spicy Leek and Shrimp Stir-Fry',
    url: 'http://www.foodnetwork.com/recipes/food-network-kitchens/quick-spicy-leek-and-shrimp-stir-fry.html',
    ingredients:
      Ingredient.mass_produce(
        'leeks',
        'vegetable oil',
        'salt',
        'black pepper',
        'red pepper flakes',
        'shrimp',
        'garlic'
      )
  ),
  Recipe.create!(
    name: 'Good Eats Meatloaf',
    url: 'http://www.foodnetwork.com/recipes/alton-brown/good-eats-meat-loaf-recipe.html',
    ingredients:
      Ingredient.mass_produce(
        'croutons',
        'black pepper',
        'cayenne pepper',
        'chili powder',
        'thyme',
        'onion',
        'carrot',
        'garlic',
        'red bell pepper',
        'ground chuck',
        'ground sirloin',
        'salt',
        'egg'
      )
  ),
  Recipe.create!(
    name: 'Guacamole',
    url: 'http://www.foodnetwork.com/recipes/alton-brown/guacamole-recipe.html',
    ingredients:
      Ingredient.mass_produce(
        'avocados',
        'lime juice',
        'salt',
        'cumin',
        'cayenne',
        'onion',
        'jalapeno',
        'roma tomatoes',
        'cilantro',
        'garlic'
      )
  ),
  Recipe.create!(
    name: 'French Toast',
    url: 'http://www.foodnetwork.com/recipes/alton-brown/french-toast-recipe.html',
    ingredients:
      Ingredient.mass_produce(
        'half and half',
        'egg',
        'honey',
        'salt',
        'brioche',
        'butter'
      )
  ),
  Recipe.create!(
    name: 'Hot Spinach and Artichoke Dip',
    url: 'http://www.foodnetwork.com/recipes/alton-brown/hot-spinach-and-artichoke-dip-recipe.html',
    ingredients:
      Ingredient.mass_produce(
        'spinach',
        'artichoke hearts',
        'cream cheese',
        'sour cream',
        'mayonnaise',
        'parmesan', 
        'red pepper flakes',
        'salt',
        'garlic'
      )
    )
].each do |recipe|
  RecordPairings.run!(recipe: recipe)
end

SearchIngredient.create!(ingredients_csv: "salt")
SearchIngredient.create!(ingredients_csv: "olive oil,pepper")