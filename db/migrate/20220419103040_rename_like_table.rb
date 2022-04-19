class RenameLikeTable < ActiveRecord::Migration[6.1]
  def change
    rename_table :like, :likes
  end
end
