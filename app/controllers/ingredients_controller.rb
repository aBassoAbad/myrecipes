class IngredientsController < ApplicationController
    before_action :set_ingredient, only: [:edit, :update, :show]
    before_action :require_admin, except: [:show, :index]
    def show
        @ingredient_recipes = @ingredient.recipes.page(params[:page]).per(3)
    end

    def index
        @ingredients = Ingredient.page(params[:page]).per(3)
    end

    def new
        @ingredient = Ingredient.new
    end

    def create
        @ingredient = Ingredient.new(ingredient_params)
        if @ingredient.save
            flash[:succcess] = "Ingredient was successfully created"
            redirect_to ingredient_path(@ingredient)
        else
            render "new"
        end
    end

    def edit

    end

    def update
        if @ingredient.update(ingredient_params)
            flash[:succcess] = "Ingredient name was successfully updated"
            redirect_to @ingredient
        else
            render "edit"
        end
    end

    private

    def set_ingredient
        @ingredient = Ingredient.find(params[:id])
    end

    def ingredient_params
        params.require(:ingredient).permit(:name)
    end

    def require_admin
        if !logged_in? || ( logged_in? and !current_chef.admin?)
            flash[:alert] = "Only admin user can perform that action"
            redirect_to ingredients_path
        end
    end
end