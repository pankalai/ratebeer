class CacheUpdate
  include SuckerPunch::Job

  def perform
    time = 5.minutes
    Rails.cache.write("beers and ratings", Beer.includes(ratings: { user: [] }).sort_by{ |b| [b.average_rating, b.ratings.count] }, expires_in: time) # if cache_does_not_contain_data("beers and ratings")

    Rails.cache.write("brewery top 3", Brewery.top(3), expires_in: time) # if cache_does_not_contain_data("brewery top 3")
    Rails.cache.write("beer top 3", Beer.top(3), expires_in: time) # if cache_does_not_contain_data("beer top 3")
    Rails.cache.write("style top 3", Style.top(3), expires_in: time) # if cache_does_not_contain_data("style top 3")
    Rails.cache.write("user top 3", User.top(3), expires_in: time) # if cache_does_not_contain_data("user top 3")

    CacheUpdate.perform_in(time)
  end

  # def cache_does_not_contain_data(name)
  #   return !Rails.cache.exist?(name)
  # end
end
