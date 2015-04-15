Fabricator(:user) do 
  name                         { Faker::Name.first_name }
  is_provider                  false
  is_admin                     false
  gender                       { Fabricate.build(:binary_gender) }
  contact                      
  password                     "test123"
  password_confirmation        "test123"
end

Fabricator(:nonbinary_user, from: :user) do 
  gender                       { Fabricate.build(:nonbinary_gender) }
end