require 'spec_helper'

RSpec.feature "Sign Up", :type => :feature do

    before do 
    @email    = "test@example.com"
    @phone    = "1-111-111-1111"
    @password = "foobar"
    @user = Fabricate(:user,
      password:              @password,
      password_confirmation: @password,
      contact: 
        Fabricate.build(:contact, 
        email:             @email,
        phone:             @phone))
    @signup_page = SignUpPage.new
    @signup_page.load
  end

  context "User navigates to the sign up page" do

    it "is at /signup" do
      expect(@signup_page.current_url).to end_with '/signup'
    end
    it "displays the form" do
      expect(@signup_page).to be_displayed
    end

  end



  context "with valid credentials" do
  # it "creates a new user account" do
  #   visit signup_path
  #   expect{
  #     fill_in 'user_name',                      with: "John"
  #     fill_in 'user_contact_attributes_email',  with: "john@gmail.com"
  #     fill_in 'user_contact_attributes_phone',  with: "475-555-1234"
  #     # Location
  #     choose  'user_gender_attributes_trans_false'
  #     select  'Male',      from: 'user_gender_attributes_identity'
  #     choose  'user_is_provider_true'
  #     fill_in 'user_password',                  with: "password123"
  #     fill_in 'user_password_confirmation',     with: "password123"
  #     click_button "submit_signup"
  #   }.to change(User,:count).by(1)
  # end

  # check that all attributes of user created match what was input correctly...
  end

end