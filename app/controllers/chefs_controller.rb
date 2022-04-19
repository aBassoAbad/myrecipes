class ChefsController < ApplicationController
    before_action :set_chef, only: [:show, :edit, :update, :destroy]
    before_action :require_same_user, only: [:edit, :update, :destroy]
    before_action :require_admin, only: [:destroy]
    def index
        @chefs = Chef.page(params[:page]).per(2)
    end
   
    def new 
        @chef = Chef.new
    end

    def create
        @chef = Chef.new(chef_params)
        if @chef.save
            session[:chef_id] = @chef.id
            cookies.signed[:chef_id] = @chef.id
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
        if !@chef.admin?
            @chef.destroy
            flash[:danger] = "Chef and all associate recipes have been deleted"
            redirect_to chefs_path
        end
    end
    
    private
      
    def chef_params
        params.require(:chef).permit(:chef_name, :email, :password, :password_confirmation)
    end

    def set_chef
        @chef = Chef.find(params[:id])
    end

    def require_same_user
        if current_chef != @chef and !current_chef.admin?
            flash[:alert] = "You can only edit or destroy your own account"
            redirect_to chefs_path
        end
    end

    def require_admin
        if logged_in? != @chef and !current_chef.admin?
            flash[:alert] = "Only admin user can perform that action"
            redirect_to root_path
        end
    end
end