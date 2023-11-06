class WeatherApi
  def self.weather_in(city)
    weather_city = "weather_#{city.downcase}"
    Rails.cache.fetch(weather_city, expires_in: 1.day) { get_weather_in(city) }
  end

  def self.get_weather_in(city)
    url = "http://api.weatherstack.com/current?access_key=#{key}&query=#{ERB::Util.url_encode(city)}"

    response = HTTParty.get url
    current = response.parsed_response["current"]

    Weather.new(current)
  end

  def self.key
    "93ef6d76aec57e8f492204f6428337a7"
  end
end
