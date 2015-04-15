Fabricator(:gender) do 
  identity        { %w(Male Female).sample } #Binary by default
  trans           false
  cp              false
end


Fabricator(:nonbinary_gender, from: :gender) do 
  identity        "Nonbinary"
  trans           true
  cp              true
  they            "they"
  them            "them"
  their           "their"
end