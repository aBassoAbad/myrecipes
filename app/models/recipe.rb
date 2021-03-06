class Recipe < ApplicationRecord
    validates :name, presence: true
    validates :description, presence: true, length: {minimum: 5, maximum: 500}
    belongs_to :chef
    validates :chef_id, presence: true
    default_scope -> {order(updated_at: :desc)}
    has_many :recipe_ingredients
    has_many :ingredients, through: :recipe_ingredients
    has_many :comments, dependent: :destroy
    has_many :likes, dependent: :destroy
    has_one_attached :image
    
    def thumbs_up_total
        Like.where(like: true, recipe: self).size
    end
    
    def thumbs_down_total
        Like.where(like: false, recipe: self).size   
    end
end