require 'spec_helper'

RSpec.describe "sign up page", :type => :feature do

  context "with valid credentials" do
    it "creates a new user account" do
      visit signup_path
      expect{
        fill_in 'user_name',                      with: "John"
        fill_in 'user_contact_attributes_email',  with: "john@gmail.com"
        fill_in 'user_contact_attributes_phone',  with: "475-555-1234"
        # Location
        choose  'user_gender_attributes_trans_false'
        select  'Male',      from: 'user_gender_attributes_identity'
        choose  'user_is_provider_true'
        fill_in 'user_password',                  with: "password123"
        fill_in 'user_password_confirmation',     with: "password123"
        click_button "submit_signup"
      }.to change(User,:count).by(1)
    end
  end

end