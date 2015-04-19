Fabricator(:gender, aliases: [:binary_gender]) do 
  identity        { %w(Male Female).sample } #Binary by default
  trans           false
  cp              false
end


Fabricator(:nonbinary_gender, aliases: [:custom_pronoun_gender], from: :gender) do 
  identity        { %w(Nonbinary Agender Genderqueer Genderfluid Bigender).sample }
  trans           true
  cp              true
  they            "They"
  them            "Them"
  their           "Their"
end