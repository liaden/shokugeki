class RecipesController < ApplicationController
  def index
    @recipes = Recipe.all
  end

  def show
    @recipe = Recipe.find(params[:id])

    recipe_graph_widget
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = Recipe.new(recipe_params)
    result = RecordIngredients.run(recipe: @recipe, ingredients: ingredients)

    if result.success?
      recipe_graph_widget
      render:show
    else
      copy_ingredients_error(result)
      render :new
    end
  end

  def edit
    @recipe = Recipe.find(params[:id])
  end

  def update
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :url)
  end

  def ingredients
    params[:recipe][:ingredients_csv].split(',').map(&:strip)
  end

  def copy_ingredients_error(command_result)
    if error_symbol = command_result.errors["ingredients"].try(:symbolic)
      @recipe.errors.add(:ingredients_csv, I18n.t(error_symbol, scope: "simple_form.errors.recipe"))
    end
  end

  def recipe_graph_widget
    graph_widget_data(
      SearchIngredient.new(ingredients_csv: @recipe.ingredients_csv, hidden_ingredients_csv: SearchIngredient.best_hidden_ingredients))
  end
end
