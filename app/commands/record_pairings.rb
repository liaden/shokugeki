class RecordPairings < Mutations::Command
  required do
    model :recipe
  end

  optional do
    array :previous_ingredients, default: []
  end

  def execute
    # if not performant:
    #   data set could be broken down to deleted pairings, unchanged pairings, and new pairings
    #   sql query to update occurrences by -1 for deleted pairings
    #   sql query to update new pairings by +1 for added pairings

    ingredients.sort_by(&:name).combination(2).each do |first, second|
      pairing = IngredientPairing.find_or_initialize_by(first_ingredient_id: first.id, second_ingredient_id: second.id)
      pairing.recompute_occurrences
      pairing.save!
    end
  end

  private

  def recipe
    inputs[:recipe]
  end

  def ingredients
    @ingredients ||= (recipe.ingredients + inputs[:previous_ingredients]).uniq
  end
end