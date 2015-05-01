require 'spec_helper'
require 'support/pages/session_pages'

RSpec.feature "Sign In", :type => :feature do
  before do 
    @email    = "test@example.com"
    @phone    = "1-111-111-1111"
    @password = "foobar"
    @user = Fabricate(:user,
      password:              @password,
      password_confirmation: @password,
      contact: 
        Fabricate.build(:contact, 
        email:               @email,
        phone:               @phone))
    @signin_page = SignInPage.new
    @signin_page.load

    @logged_in_text = "Signed in as #{@user.name}"
  end

  context "User navigates to the sign in page" do
    it "is at /signin" do
      expect(@signin_page.current_url).to end_with '/signin'
    end
    it "displays the form" do
      expect(@signin_page).to be_displayed
    end
  end

  context "with valid credentials" do
    it "signs in with correct email address and password" do
      @signin_page.username_field.set @email
      @signin_page.password_field.set @password
      @signin_page.signin_button.click
      expect(page).to have_content @logged_in_text
    end

    it "signs in with correct phone and password" do
      @signin_page.username_field.set @phone
      @signin_page.password_field.set @password
      @signin_page.signin_button.click
      expect(page).to have_content @logged_in_text
    end
  end

  context "with invalid credentials" do
    before :each do
      @signin_page.username_field.set @phone
      @signin_page.password_field.set "wrong! #{@password}"
      @signin_page.signin_button.click
    end

    it "does not successfully log in with the wrong password" do
      expect(page).to_not have_content @logged_in_text
    end

    it "displays an appropriate error message if user does not exist" do
      expect(page).to have_content "Entered credentials do not match any registered accounts."
    end

  end


  context "after signing in" do
    it "redirects the user to their profile" do
      @user_profile = ProfilePage.new

      @signin_page.username_field.set @phone
      @signin_page.password_field.set @password
      @signin_page.signin_button.click

      expect(@user_profile).to be_displayed(id: @user.id.to_s)
    end
  end
end