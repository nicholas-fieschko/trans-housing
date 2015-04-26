Fabricator(:message) do

	#sender			{ Fabricate.build(:user).id }
	#receiver		{ Fabricate.build(:user).id }

	text			{ Faker::Lorem.sentence(3) }

end
