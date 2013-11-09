json.array!(@purchases) do |purchase|
  json.extract! purchase, :title, :price
  json.url purchase_url(purchase, format: :json)
end
