# Ensure that when Fabricate builds a message, it has enough text and that it
# has an author (just grab a random User)
Fabricator(:message) do
	text	{ Faker::Lorem.characters(char_count = 255) }
	author	{ User.last }
end
