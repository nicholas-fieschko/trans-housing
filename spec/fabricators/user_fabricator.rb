Fabricator(:user) do 
  name                         { Faker::Name.first_name }
  is_provider                  false
  is_admin                     false
  gender                       { Fabricate.build(:gender) }
  contact                      
  password                     "test123"
  password_confirmation        "test123"
end