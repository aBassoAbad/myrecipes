require "test_helper"

class ChefTest < ActiveSupport::TestCase

    def setup
        @chef = Chef.new(chef_name: "Alejandro", email: "alejandro@correo.com", password: "password", password_confirmation: "password")
    end

    test "Chef should be valid" do
        assert @chef.valid?
    end

    test "Name should be present" do
        @chef.chef_name = " "
        assert_not @chef.valid?
    end

    test "Name should be less than 30 characters" do
        @chef.chef_name = "a" * 31
        assert_not @chef.valid?
    end

    test "Email should be present" do
        @chef.email = " "
        assert_not @chef.valid?
    end

    test "Email should not be too long" do
        @chef.email = "a" * 256 + "@correo.com"
        assert_not @chef.valid?
    end

    test "Email should accept correct format" do
        valid_emails = %w[user@example.com ALEX@gmail.com M.first@yahoo.co john+smith@co.uk.org]
        valid_emails.each do |valids|
            @chef.email = valids
            assert @chef.valid?, "#{valids.inspect} should be valid"
        end
    end 
    
    test "Should reject invalid email addresses" do
        invalid_emails = %w[user@example ALEX@gmail,.com M.firstyahoo.co john+smith@co..org]
        invalid_emails.each do |invalids|
            @chef.email = invalids
            assert_not @chef.valid?, "#{invalids.inspect} should be invalid"
        end
    end

    test "Email should be unique and case insensitive" do
        duplicate_chef = @chef.dup
        duplicate_chef.email = @chef.email.upcase
        assert_not duplicate_chef.valid?
    end

    test "Email should be lower case before hittind db" do
        mixed_email = "ALEX@Correo.com"
        @chef.email = mixed_email
        @chef.save
        assert_equal mixed_email.downcase, @chef.reload.email
    end

    test "Password should be present" do
        @chef.password = @chef.password_confirmation = " "
        assert_not @chef.valid?
    end

    test "Password should be atleast 5 characters" do
        @chef.password = @chef.password_confirmation = "x" * 4
        assert_not @chef.valid?
    end

    test "associated recipes should be destroyed" do
        @chef.save
        @chef.recipes.create(name: "Testing", description: "testing destroy")
        assert_difference "Recipe.count", -1 do
            @chef.destroy
        end
    end
end