class BeerClub < ApplicationRecord
  has_many :memberships
  has_many :users, through: :memberships

  def members
    User.joins(:beer_clubs).where("beer_clubs.id=?", id)
  end
end
