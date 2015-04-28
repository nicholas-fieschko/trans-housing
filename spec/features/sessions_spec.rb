require 'spec_helper'
require 'support/pages/signin_page'

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
        email:             @email,
        phone:             @phone))
    @id = @user.id.to_s
    @user_profile = ProfilePage.new
    @signin_page = SignInPage.new
    @user_profile.load(id: @id)
    @signin_page.load
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
      expect(page).to have_content "Signed in as #{@user.name}"
    end

    it "signs in with correct phone and password" do
      @signin_page.username_field.set @phone
      @signin_page.password_field.set @password
      @signin_page.signin_button.click
      expect(page).to have_content "Signed in as #{@user.name}"
    end
  end

  context "with invalid credentials" do
    it "does not successfully log with the wrong password" do
      @signin_page.username_field.set @phone
      @signin_page.password_field.set "wrong! #{@password}"
      @signin_page.signin_button.click
      expect(page).to_not have_content "Signed in as #{@user.name}"
    end
  end
end