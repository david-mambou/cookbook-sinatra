require 'csv'

class Cookbook
  def initialize(csv_file_path)
    @path = csv_file_path
    @recipes = []
    @csv_options = { col_sep: ',', force_quotes: true }
    CSV.foreach(@path, @csv_options) do |row|
      @recipes << Recipe.new({ name: row[0],
                               description: row[1],
                               rating: row[2],
                               prep_time: row[3],
                               done: row[4] == 'true' })
    end
  end

  def all
    @recipes
  end

  def at_index(index)
    @recipes[index]
  end

  def add_recipe(recipe)
    @recipes << recipe
    save_csv
  end

  def save_csv
    CSV.open(@path, 'wb', @csv_options) do |csv|
      @recipes.each do |recipe|
        csv << [recipe.name, recipe.description, recipe.rating, recipe.prep_time, recipe.done]
      end
    end
  end

  def remove_recipe(recipe_index)
    @recipes.delete_at(recipe_index)
    save_csv
  end
end
