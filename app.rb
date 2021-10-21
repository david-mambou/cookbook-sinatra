require 'nokogiri'
require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
require_relative 'lib/cookbook'
require_relative 'lib/recipe'
require_relative 'lib/scrape_allrecipes_service'
set :bind, '0.0.0.0'

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

get '/' do
  cookbook = Cookbook.new('lib/recipes.csv')
  @recipes = cookbook.all
  erb :index
end

get '/new' do
  erb :new
end

# get '/new/:keyword' do
#   @results = ScrapeAllrecipesService.new(params[:keyword]).call
#   erb :select
# end

# get '/import' do
#   erb :import
# end

post '/recipes' do
  recipe = Recipe.new(name: params['name'],
                      description: params['description'],
                      rating: params['rating'],
                      prep_time: params['prep_time'])
  cookbook = Cookbook.new('lib/recipes.csv')
  cookbook.add_recipe(recipe)
  redirect to '/'
end

# get '/recipes/add/:index' do
#   recipe = Recipe.new(name: params['name'],
#                       description: params['description'],
#                       rating: params['rating'],
#                       prep_time: params['prep_time'])
#   cookbook = Cookbook.new('lib/recipes.csv')
#   cookbook.add_recipe(recipe)
#   redirect to '/'
# end

get '/recipes/:index' do
  cookbook = Cookbook.new('lib/recipes.csv')
  cookbook.remove_recipe(params[:index].to_i)
  redirect to '/'
end

get '/recipes/mark_done/:index' do
  cookbook = Cookbook.new('lib/recipes.csv')
  cookbook.at_index(params[:index].to_i).done!
  cookbook.save_csv
  redirect to '/'
end

get '/about' do
  erb :about
end

get '/team/:username' do
  puts params[:username]
  "The username is #{params[:username]}"
end
