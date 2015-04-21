Fabricator(:location) do
  transient lat:        (41..42).to_a.sample
  transient lng:        (-72..73).to_a.sample
  coordinates           { |attrs| [ attrs[:lat], attrs[:lng] ] }
end
