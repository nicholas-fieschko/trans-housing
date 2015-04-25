Fabricator(:gender, aliases: [:binary_gender]) do 
  identity        { %w(male female).sample }
  trans           false
  cp              false
end


Fabricator(:nonbinary_gender, from: :gender) do 
  identity        { %w(nonbinary agender genderqueer genderfluid bigender).sample }
  trans           true
  cp              false
end

Fabricator(:custom_pronoun_gender, from: :nonbinary_gender) do
  cp              true
  they            "xe"
  them            "hir"
  their           "hir"
end