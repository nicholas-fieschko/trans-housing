class SignInPage < SitePrism::Page
  set_url '/signin'

  element :username_field,       "#session_username"  
  element :password_field,       "#session_password"
  element :signin_button,        "#session_submit"
  
end

class ProfilePage < SitePrism::Page
  set_url '/users{/id}'
  element :user_name,             "#user-name"
end