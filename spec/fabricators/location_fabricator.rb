Fabricator(:location) do
  transient lat:        rand(1000)/1000.0 + 41 
  transient lng:        rand(1000) / 1000.0 - 74 
  coordinates           { |attrs| [ attrs[:lat], attrs[:lng] ] }

  # user
end
