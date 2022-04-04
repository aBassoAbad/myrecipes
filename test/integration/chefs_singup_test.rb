require "test_helper"

class ChefsSingupTest < ActionDispatch::IntegrationTest
  test "shoulg get sing up path" do
    get signup_path
    assert_response :success
  end

  test "reject invalid signup" do
    get signup_path
    assert_no_difference "Chef.count" do
        post.chefs_path, params{chef: {chef_name: " ", email: " ", password: "password", password_cofirmation: " "}}
    end
    assert_template "chefs/new"

  end

  test "acept valid signup" do
    get signup_path
    assert_difference "Chef.count", 1 do
        post.chefs_path, params{chef: {chef_name: "alejandro", email: "alejandro@correo.com",
                                    password: "password", password_cofirmation: "password"}}
    end
    follow_redirect!
    assert_template "chefs/show"
    assert_not flash.empty?
  end
end
