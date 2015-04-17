Fabricator(:location) do
  transient lat:        (-180..180).to_a.sample
  transient lng:        (-90..90).to_a.sample
  coordinates           { |attrs| [ attrs[:lat], attrs[:lng] ] }
end