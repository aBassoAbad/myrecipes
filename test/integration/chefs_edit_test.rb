require "test_helper"

class ChefsEditTest < ActionDispatch::IntegrationTest
    def setup
        @chef = Chef.create!(chefname: "alejandro", 
                           email: "alejandro@correo.com",
                               password: "password", 
                               password_confirmation: "password")
        @chef2 = Chef.create!(chefname: "alejandro2", 
                            email: "alejandro2@correo.com",
                                password: "password", 
                                password_confirmation: "password")
        @admin = Chef.create!(chefname: "alejandro3", 
                            email: "alejandro3@correo.com",
                                password: "password", 
                                password_confirmation: "password", admin: true)
       end
       
       test "reject an invalid edit" do
         get edit_chef_path(@chef)
         assert_template 'chefs/edit'
         patch chef_path(@chef), params: { chef: { chefname: " ", 
                                   email: "alejandro@correo.com" } }
         assert_template 'chefs/edit'
       end
       
       test "accept valid edit" do
         sing_in_as(@chef)
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

       test "accept edit attempt by admin user" do
        sing_in_as(@admin)
        get edit_chef_path(@chef)
        assert_template 'chefs/edit'
        patch chef_path(@chef), params: { chef: { chefname: "alejandro5", 
                                    email: "alejandro5@correo.com" } }
        assert_redirected_to @chef
        assert_not flash.empty?
        @chef.reload
        assert_match "alejandro5", @chef.chefname
        assert_match "alejandro5@correo.com", @chef.email
       end

       test "redirect edit attemp by another non-admin user" do
        sing_in_as(@chef2)
        updated_name = "alejandro6"
        updated_email = "alejandro6@correo.com"
        patch chef_path(@chef), params: { chef: { chefname: updated_name, 
                                    email: updated_email } }
        assert_redirected_to chefs_path
        assert_not flash.empty?
        @chef.reload
        assert_match "alejandro", @chef.chefname
        assert_match "alejandro@correo.com", @chef.email
       end
end
