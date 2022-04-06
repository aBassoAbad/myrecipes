require "test_helper"

class RecipesTest < ActionDispatch::IntegrationTest
    def setup 
        @chef = Chef.create!(chef_name: "alejandro", email: "alejandro@correo.es", password: "password", password_confirmation: "password")
        @recipe = Recipe.create(name: "macarrones", description: "con tomatico", chef: @chef)
        @recipe2 = @chef.recipes.build(name: "ensalada", description: "ensalada de tomate")
        @recipe2.save
    end
    
    test "should get recipes index" do
        get recipes_url
        assert_response :success
    end

    test "should get recipes listing" do
        get recipes_path
        assert_template "recipes/index"
        assert_select "a[href=?]", recipe_path(@recipe), text: @recipe.name
        assert_select "a[href=?]", recipe_path(@recipe2), text: @recipe2.name
    end

    test "should get recipes show" do
        sing_in_as(@chef, "password")
        get recipe_path(@recipe)
        asser_template "recipe/show"
        assert_match @recipe.name, response.body
        assert_match @recipe.description, response.body
        assert_match @chef.chef_name, response.body
        assert_select "a{href=?]", edit_recipe_path(@recipe), text: "Edit this recipe"
        assert_select "a{href=?]", recipe_path(@recipe), text: "Delete this recipe"
        assert_select "a{href=?]", recipes_path, text: "Return to recipe listing"
    end

    test "create new valid recipe" do
        sing_in_as(@chef, "password")
        get new_recipe_path
        assert_template "recipes/new"
        name_of_recipe = "Pollo"
        description_of_recipe = "Pollo al horno con patatas"
        asser_no_difference "Recipe.count", 1 do
            post recipe_path, params: {recipe: {name: name_of_recipe, description: description_of_recipe}}
        end
        follow_redirect!
        assert_match name_of_recipe.capitalize, response.body
        assert_match description_of_recipe, response.body
    end

    test "reject invalid recipe submission" do
        get new_recipe_path
        assert_template "recipes/new"
        assert_no_difference "Recipe.count" do
            post recipe_path, params: {recipe: {name: " ", description: " "}}
        end
        assert_template "recipes/new"
    end
end
