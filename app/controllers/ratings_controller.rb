class RatingsController < ApplicationController
  before_action :clear_cache, only: [:create, :destroy]

  def index
    # @ratings = Rating.includes(:beer, :user).all
    @ratings = Rating.all

    # @beers_and_ratings = Beer.includes(:ratings).sort_by{|b| [b.average_rating, b.ratings.count]}
    @beers_and_ratings = Rails.cache.fetch("beers and ratings", expires_in: 5.minutes) { Beer.includes(ratings: { user: [] }).sort_by{ |b| [b.average_rating, b.ratings.count] } }
    @top_breweries = Rails.cache.fetch("brewery top 3", expires_in: 5.minutes) { Brewery.top(3) }
    @top_beers = Rails.cache.fetch("beer top 3", expires_in: 5.minutes) { Beer.top(3) }
    @top_styles = Rails.cache.fetch("style top 3", expires_in: 5.minutes) { Style.top(3) }
    @active_users = Rails.cache.fetch("user top 3", expires_in: 5.minutes) { User.top(3) }

    # CacheUpdate.perform_async
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    # Otetaan luotu reittaus muuttujaan
    @rating = Rating.create params.require(:rating).permit(:score, :beer_id)
    @rating.user = current_user

    if @rating.save
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    rating = Rating.find(params[:id])
    rating.delete if current_user == rating.user
    redirect_to user_path(current_user)
  end

  def clear_cache
    clear_brewery_cache
  end
end
