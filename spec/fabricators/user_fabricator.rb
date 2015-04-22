Fabricator(:user) do 
  name                         { Faker::Name.first_name }
  is_provider                  [true, false].sample
  is_admin                     false
  location                     { Fabricate.build(:location) }
  gender                       { Fabricate.build(:binary_gender) }
  contact                      { Fabricate.build(:contact) }

  password                     "test123"
  password_confirmation        "test123"

  number_reviews                0
  average_rating                0.0
  sum_rating                    0


  food_resource                 { [true,false].sample ? Fabricate.build(:food_resource) :           nil }                 
  shower_resource               { [true,false].sample ? Fabricate.build(:shower_resource) :         nil }
  laundry_resource              { [true,false].sample ? Fabricate.build(:laundry_resource) :        nil }
  housing_resource              { [true,false].sample ? Fabricate.build(:housing_resource) :        nil }
  transportation_resource       { [true,false].sample ? Fabricate.build(:transportation_resource) : nil }
  buddy_resource                { [true,false].sample ? Fabricate.build(:buddy_resource) :          nil }
  misc_resource                 { [true,false].sample ? Fabricate.build(:misc_resource) :           nil }
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
