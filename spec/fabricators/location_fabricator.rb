Fabricator(:location) do

  zip                   { ["06501", "06502", "06503",
                           "06504", "06505", "06506", 
                           "06507", "06508", "06509", 
                           "06510", "06511", "06513", 
                           "06515", "06519", "06520", 
                           "06521", "06530", "06531", 
                           "06532", "06533", "06534", 
                           "06535", "06536", "06537", 
                           "06538", "06540"].sample }
  city                  "New Haven"        #{ Faker::Address.city }
  state                 "Connecticut"     #{ Faker::Address.state }
  country               "USA"           #{ Faker::Address.country }

  coordinates           { [ (rand * 1) - 73.1, (rand * 0.2) + 41.3 ] }
  # Below is Albany...or change it to something else...try to seed twice
  # using two different coordinate for demo
  #coordinates           { [ (rand * 1) - 73.76, (rand * 0.3) + 42.65 ] }
end
