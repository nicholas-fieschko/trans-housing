Fabricator(:location) do
  transient lat:        (41.300..42.500).to_a.sample
  transient lng:        (-72.910..73.100).to_a.sample
  coordinates           { |attrs| [ attrs[:lat], attrs[:lng] ] }
end
