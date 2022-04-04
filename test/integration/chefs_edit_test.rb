require "test_helper"

class ChefsEditTest < ActionDispatch::IntegrationTest
    def setup
        @chef = Chef.create!(chef_name: "alejandro", email: "alejandro@correo.es", password: "password",
             password_confirmation: "password")
    end

    test "reject invalid edit" do
        get edit_chef_path(@chef)
        assert_template "chefs/edit"
        patch.chef_path(@chef), params{chef: {chef_name: " ", email: "alejandro@correo.com"}}
        assert_template "chefs/edit"
      end
    
      test "acept valid signup" do
        get edit_chef_path(@chef)
        assert_template "chefs/edti"
        patch.chef_path(@chef), params{chef: {chef_name: "alejandro1", email: "alejandro1@correo.com"}}
        assert_redirect_to @chef
        assert_not flash.empty?
        @chef.reload
        assert_match "alejandro1", @chef.chef_name
        assert_match "alejandro1@correo.com", @chef.email
      end
end
