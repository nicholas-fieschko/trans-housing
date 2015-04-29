Fabricator(:user) do 
  name                         { Faker::Name.first_name                       }
  is_provider                  { [true, false].sample                         }
  is_admin                     false
  location                     { Fabricate.build(:location)                   }
  gender                       { Fabricate.build(:binary_gender)              }
  contact                      { Fabricate.build(:contact)                    }
  preference_profile           { Fabricate.build(:preference_profile)         }
  extended_profile             { Fabricate.build(:extended_profile)           }

  password                     "test123"
  password_confirmation        "test123"

  number_reviews                { rand(100)                                   }
  average_rating                { rand(1.0..5.0).round(1)                     }
  sum_rating                    0


  food_resource                 { Fabricate.build(:food_resource, 
                                    currently_offered: [true, false].sample)  }                 
  shower_resource               { Fabricate.build(:shower_resource, 
                                    currently_offered: [true, false].sample)  }
  laundry_resource              { Fabricate.build(:laundry_resource, 
                                    currently_offered: [true, false].sample)  }
  housing_resource              { Fabricate.build(:housing_resource, 
                                    currently_offered: [true, false].sample)  }
  transportation_resource       { Fabricate.build(:transportation_resource, 
                                    currently_offered: [true, false].sample)  }
  buddy_resource                { Fabricate.build(:buddy_resource, 
                                    currently_offered: [true, false].sample)  }
  misc_resource                 { Fabricate.build(:misc_resource, 
                                    currently_offered: [true, false].sample)  }
end

Fabricator(:provider, from: :user) do
  is_provider                  true
end

Fabricator(:seeker, from: :user) do
  is_provider                  false
end

Fabricator(:nonbinary_user, from: :user) do 
  gender                        { Fabricate.build(:nonbinary_gender)          }
end

Fabricator(:custom_pronoun_user, from: :nonbinary_user) do
  gender                        { Fabricate.build(:custom_pronoun_gender)     }
end