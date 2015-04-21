Fabricator(:contact) do 
  email           { Fabricate.sequence(:email) {|i| "#{i}@internet.com" } }
  phone           { Fabricate.sequence(:phone) {|i| "#{i}-#{Faker::PhoneNumber.phone_number}" } }
end

Fabricator(:phone_only, from: :contact) do 
  email           nil
end

Fabricator(:email_only, from: :contact) do 
  phone           nil
end
