require "test_helper"

class RecipesTest < ActionDispatch::IntegrationTest
    def setup 
        @user = Chef.create!(chef_name: "alejandro", email: "alejandro@correo.es")
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
        assert_match @recipe.name, response.body
        assert_match @recipe2.name, response.body
    end
end
