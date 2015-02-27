json.array!(@breweries) do |brewery|
  json.extract! brewery, :name, :year
  json.beers do
    json.count brewery.beers.count
  end
end
