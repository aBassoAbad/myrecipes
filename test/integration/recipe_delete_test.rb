require "test_helper"

class RecipeDeleteTest < ActionDispatch::IntegrationTest
    def setup 
        @chef = Chef.create!(chef_name: "alejandro", email: "alejandro@correo.es")
        @recipe = Recipe.create(name: "macarrones", description: "con tomatico", chef: @chef)
    end

    test "Successfully delete a recipe" do
        get recipe_path(@recipe)
        assert_template "recipes/show"
        assert_select "a{href=?]", recipe_path(@recipe), text: "Delete this recipe"
        assert_difference "Recipe.count", -1 do
            delete recipe_path(@recipe)
        end
        assert_redirect_to recipe_path
        assert_not flash.empty?
    end
end
