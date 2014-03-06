json.array!(@offers) do |offer|
  json.extract! offer, :id
  json.url offer_url(offer, format: :json)
end
