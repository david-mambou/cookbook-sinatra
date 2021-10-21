require 'nokogiri'
require 'open-uri'
require_relative 'recipe'

class ScrapeAllrecipesService
  def initialize(keyword)
    @keyword = keyword
  end

  def call(recipes = [])
    html_doc = Nokogiri::HTML(URI.open("https://www.allrecipes.com/search/results/?search=#{@keyword}.").read, nil, 'utf-8')
    html_doc.search('.card__detailsContainer').first(5).each do |card|
      name = card.search('.card__title').text.strip
      desc = card.search('.card__summary').text.strip
      rating = card.search('.review-star-text').text.match(/[\d|.]+/).to_s.to_f
      page = Nokogiri::HTML(URI.open(card.css('a')[0]['href']).read, nil, 'utf-8')
      prep_time = page.search('.recipe-meta-item-body').first.text.strip
      recipes << Recipe.new({ name: name, description: desc, rating: rating, prep_time: prep_time })
    end
    recipes
  end
end
