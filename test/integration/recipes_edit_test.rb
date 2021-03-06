require "test_helper"

class RecipesEditTest < ActionDispatch::IntegrationTest
    def setup 
        @chef = Chef.create!(chef_name: "alejandro", email: "alejandro@correo.es", password: "password", password_confirmation: "password")
        @recipe = Recipe.create(name: "macarrones", description: "con tomatico", chef: @chef)
    end

    test "reject invalid recipe update" do
        get edit_recipe_path(@recipe)
        assert_template "recipes/edit"
        patch recipe_path(@recipe), params: { recipe: {name: " ", description: "Some description"}}
        assert_template "recipes/edit"
        
    end

    test "successfully edit recipe" do
        get edit_recipe_path(@recipe)
        assert_template "recipes/edit"
        updated_name = "Updated recipe name"
        updated_description = "Updated recipe description"
        patch recipe_path(@recipe), params: {recipe: {name: updated_name, description: updated_description}}
        assert_redirected_to @recipe
        assert_not flash.empty?
        @recipe.reload
        assert_match updated_name, @recipe.name
        assert_match updated_description, @recipe.description
    end
end
