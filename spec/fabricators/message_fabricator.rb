# Ensure that when Fabricate builds a message, it has enough text and that it
# has an author (just grab a random User)
Fabricator(:message) do
	text	 { Faker::Lorem.paragraph }
	author { User.last }
end
