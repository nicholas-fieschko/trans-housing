Fabricator(:contact) do 
  email           { |attrs| "#{attrs[:name].to_s}@internet.com" }
end