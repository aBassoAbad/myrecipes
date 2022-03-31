require "test_helper"

class RecipeTest < ActiveSupport::TestCase

    def setup
        @recipe = Recipe.new(name: "Receta", description: "Primera receta")
    end

    test "Recipe should be valid" do
        assert @recipe.valid?
    end

    test "Name should be present" do
        @recipe.name = " "
        assert_not @recipe.valid?
    end

    test "Description should be present" do
        @recipe.description = " "
        assert_not @recipe.valid?
    end

    test "Description shouldn't be less than 5 characters" do
        @recipe.description = "a" * 3
        assert_not @recipe.valid?
    end

    test "Description shouldn't be more than 500 characters" do
        @recipe.description = "a"*501
        assert_not @recipe.valid?
    end
end