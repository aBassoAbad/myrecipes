require "test_helper"

class ChefsEditTest < ActionDispatch::IntegrationTest
    def setup
        @chef = Chef.create!(chefname: "alejandro", 
                           email: "alejandro@correo.com",
                               password: "password", 
                               password_confirmation: "password")
       end
       
       test "reject an invalid edit" do
         get edit_chef_path(@chef)
         assert_template 'chefs/edit'
         patch chef_path(@chef), params: { chef: { chefname: " ", 
                                   email: "alejandro@correo.com" } }
         assert_template 'chefs/edit'
       end
       
       test "accept valid signup" do
         get edit_chef_path(@chef)
         assert_template 'chefs/edit'
         patch chef_path(@chef), params: { chef: { chefname: "alejandro1", 
                                     email: "alejandro@correo.com" } }
         assert_redirected_to @chef
         assert_not flash.empty?
         @chef.reload
         assert_match "alejandro1", @chef.chefname
         assert_match "alejandro1@correo.com", @chef.email
       end
end
