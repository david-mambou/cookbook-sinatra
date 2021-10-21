class Recipe
  attr_reader :name, :description, :rating, :prep_time, :done

  def initialize(attributes = {})
    @name = attributes[:name]
    @description = attributes[:description]
    @rating = attributes[:rating]
    @prep_time = attributes[:prep_time]
    @done = attributes[:done]
  end

  def done!
    @done = true
  end
end
