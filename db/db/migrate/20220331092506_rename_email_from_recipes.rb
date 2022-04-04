class RenameEmailFromRecipes < ActiveRecord::Migration[6.1]
  def change
    rename_column :recipes, :email, :description
  end
end
