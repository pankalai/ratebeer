# json.extract! beer, :id, :name, :style, :brewery
json.extract! beer, :id, :name
json.style do
  json.name beer.style.name
end
json.brewery do
  json.name beer.brewery.name
end
