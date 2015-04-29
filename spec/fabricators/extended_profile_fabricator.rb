Fabricator(:extended_profile) do
  profile_summary     { Faker::Lorem.paragraph if [true, false].sample }
end