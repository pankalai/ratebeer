json.extract! brewery, :id, :name, :year, :active
json.beers do
  json.number_of_beers brewery.beers.count
end
# json.url brewery_url(brewery, format: :json)
