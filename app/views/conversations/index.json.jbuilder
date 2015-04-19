json.array!(@conversations) do |conversation|
  json.extract! conversation, :id
  json.url conversation_url(conversation, format: :json)
end
