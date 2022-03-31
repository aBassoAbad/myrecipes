class ChangeRecipeColumn < ActiveRecord::Migration[6.1]
  def change
    change_column :recipes, :description, :text
  end
end
