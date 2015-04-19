# Ensure that when Fabricate builds a message, it has enough text and that it
# has an author (just grab a random User). Make sure it inherits from Convo.
Fabricator(:message, from: :conversation) do
	text	 { Faker::Lorem.paragraph }
	author { |attrs| attrs[:participants][1] }
end
