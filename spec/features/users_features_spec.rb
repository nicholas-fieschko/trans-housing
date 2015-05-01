require 'spec_helper'
require 'support/pages/user_pages'

RSpec.feature "Sign Up Page", type: :feature do
  before do 
    @email    = "test@example.com"
    @phone    = "1-111-111-1111"
    @password = "foobar"
    @user = Fabricate(:user,
      name:                  'Joe',
      is_provider:           true,
      password:              @password,
      password_confirmation: @password,
      contact: 
        Fabricate.build(:contact, 
        email:               @email,
        phone:               @phone),
      gender: 
        Fabricate.build(:gender, 
        identity:            'Male',
        trans:               false),
      food_resource:            Fabricate.build(:food_resource,           currently_offered:  true ),                 
      shower_resource:          Fabricate.build(:shower_resource,         currently_offered:  true ),
      laundry_resource:         Fabricate.build(:laundry_resource,        currently_offered:  true ),
      housing_resource:         Fabricate.build(:housing_resource,        currently_offered:  true ),
      transportation_resource:  Fabricate.build(:transportation_resource, currently_offered:  true ),
      buddy_resource:           Fabricate.build(:buddy_resource,          currently_offered:  true ))
    @signup_page = SignUpPage.new
    @signup_page.load
  end

  context "User navigates to the sign up page" do
    it "is at /signup" do
      expect(@signup_page.current_url).to end_with '/signup'
    end
    it "displays the sign up page" do
      expect(@signup_page).to be_displayed
    end
  end

end