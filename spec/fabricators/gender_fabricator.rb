Fabricator(:gender) do 
  identity        { %w(Male Female).sample } #Binary by default
  trans           false
  cp              false
end