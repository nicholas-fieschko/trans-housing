Fabricator(:contact) do 
  email           { "#{Faker::Name.last_name}#{User.count}@yale.edu" }
  phone           { "#{Faker::PhoneNumber.phone_number}"             }
end

Fabricator(:phone_only, from: :contact) do 
  email           nil
end

Fabricator(:email_only, from: :contact) do 
  phone           nil
end
