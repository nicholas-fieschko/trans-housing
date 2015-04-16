Fabricator(:user) do 
  name                         { Faker::Name.first_name }
  is_provider                  [true, false].sample
  is_admin                     false
  location                     { Fabricate.build(:location) }
  gender                       { Fabricate.build(:binary_gender) }
  contact                      { Fabricate.build(:contact) }
  password                     "test123"
  password_confirmation        "test123"
end

Fabricator(:provider, from: :user) do
  is_provider                  true
end

Fabricator(:seeker, from: :user) do
  is_provider                  false
end

Fabricator(:nonbinary_user, aliases: [:custom_pronoun_user], from: :user) do 
  gender                       { Fabricate.build(:nonbinary_gender) }
end