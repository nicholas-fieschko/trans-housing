Fabricator(:contact) do 
  email           { "#{Faker::Name.first_name}@internet.com" }
  phone           { Faker::PhoneNumber.phone_number }
end

Fabricator(:phone_only, from: :contact) do 
  email           nil
end

Fabricator(:email_only, from: :contact) do 
  phone           nil
end