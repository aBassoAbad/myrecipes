class ChefsController < ApplicationController
    before_action :set_chef, only: [:show, :edit, :update, :delete]
    def index
        @chefs = Chef.page(params[:page]).per(2)
    end
   
    def new 
        @chef = Chef.new
    end

    def create
        @chef = Chef.new(chef_params)
        if @chef.save
            flash[:success] = "Welcome #{@chef.chef_name} to MyRecipes App!"
            redirect_to chef_path(@chef)
        else
            render 'new'
        end
    end

    def show
        @chef_recipes = @chef.recipes.page(params[:page]).per(2)
    end

    def edit
    end

    def update
        if @chef.update(chef_params)
            flash[:success] = "Your account was updated successfully"
            redirect_to @chef
        else
            render "edit"
        end
    end

    def destroy
        @chef.destroy
        flash[:danger] = "Chef and all associate recipes have been deleted"
        redirect_to chefs_path
    end
    
    private
      
    def chef_params
        params.require(:chef).permit(:chef_name, :email, :password, :password_confirmation)
    end

    def set_chef
        @chef = Chef.find(params[:id])
    end
end