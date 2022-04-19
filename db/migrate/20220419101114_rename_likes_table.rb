class RenameLikesTable < ActiveRecord::Migration[6.1]
  def change
    rename_table :likes, :like
  end
end
