require 'rails_helper'

RSpec.describe User, type: :model do

	it "has the username set correctly" do
		user = User.new username: "Pekka"
		expect(user.username).to eq("Pekka")
	end
	
	it "is not saved without a password" do
		user = User.create username: "Pekka"
		expect(user.valid?).to be(false)
		#expect(user).not_to be_valid
		expect(User.count).to eq(0)
	end
	
	
	describe "with a proper password" do
		let(:user) { FactoryBot.create(:user) }
		#let(:test_brewery) { Brewery.new name: "test", year: 2000 }
		#let(:test_beer) { Beer.create name: "testbeer", style: "teststyle", brewery: test_brewery }
	
		it "is saved" do
			#expect(user.valid?).to be(true)
			expect(user).to be_valid
			expect(User.count).to eq(1)
		end
	
		it "and with two ratings, has the correct average rating" do
		  #rating = Rating.new score: 10, beer: test_beer
		  #rating2 = Rating.new score: 20, beer: test_beer
		  FactoryBot.create(:rating, score: 10, user: user)
		  FactoryBot.create(:rating, score: 20, user: user)

		  #user.ratings << rating
		  #user.ratings << rating2

		  expect(user.ratings.count).to eq(2)
		  expect(user.average_rating).to eq(15.0)
		end
	end
	
	describe "without a proper password" do
		let(:user){  User.create username: "Pekka", password: "secret1", password_confirmation: "secret1" }
		
		it "is not saved" do
			expect(User.count).to eq(0)
		end
		
		it "is not valid" do
			expect(user).not_to be_valid
		end
	end
	
	describe "favorite beer" do
		let(:user){ FactoryBot.create(:user) }

		it "has method for determining one" do
			expect(user).to respond_to(:favorite_beer)
		end

		it "without ratings does not have one" do
			expect(user.favorite_beer).to eq(nil)
		end

		it "is the only rated if only one rating" do
			beer = FactoryBot.create(:beer)
			rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)

			expect(user.favorite_beer).to eq(beer)
		end
		
		it "is the one with highest rating if several rated" do
		  # beer1 = FactoryBot.create(:beer)
		  # beer2 = FactoryBot.create(:beer)
		  # beer3 = FactoryBot.create(:beer)
		  # rating1 = FactoryBot.create(:rating, score: 20, beer: beer1, user: user)
		  # rating2 = FactoryBot.create(:rating, score: 25, beer: beer2, user: user)
		  # rating3 = FactoryBot.create(:rating, score: 9, beer: beer3, user: user)
		  # create_beer_with_rating({ user: user }, 10 )
		  # create_beer_with_rating({ user: user }, 7 )
		  create_beers_with_many_ratings({user: user}, 10, 20, 15, 7, 9)
		  best = create_beer_with_rating({ user: user }, 25 )

		  expect(user.favorite_beer).to eq(best)
		end
	end
	
	describe "favorite style" do
		let(:user){ FactoryBot.create(:user) }
		let(:style) {FactoryBot.create :style}

		it "has method for determining one" do
			expect(user).to respond_to(:favorite_style)
		end

		it "without ratings does not have one" do
			expect(user.favorite_style).to eq(nil)
		end

		it "is the only rated if only one rating" do
			beer = FactoryBot.create(:beer, style: style)
			rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)

			expect(user.favorite_style).to eq(style)
		end
		
		it "is the one with highest average if several rated" do
		  create_beers_with_many_ratings({user: user, style: style}, 10, 20)
		  create_beers_with_many_ratings({user: user, style: style}, 20, 30)
		  create_beers_with_many_ratings({user: user, style: style}, 30, 40)
		  b_style = FactoryBot.create(:style, name: "style1")
		  create_beer_with_rating({user: user, style: b_style}, 45 )
		  expect(user.favorite_style).to eq(b_style)
		end
	end
	
	describe "favorite_brewery" do
		let(:user){ FactoryBot.create(:user) }

		it "has method for determining one" do
			expect(user).to respond_to(:favorite_brewery)
		end

		it "without ratings does not have one" do
			expect(user.favorite_brewery).to eq(nil)
		end

		it "is the only rated if only one rating" do
			beer = FactoryBot.create(:beer)
			brewery = beer.brewery
			rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)

			expect(user.favorite_brewery).to eq(brewery.name)
		end
		
		it "is the one with highest average if several rated" do
		  #Eka
		  brewery1 = FactoryBot.create(:brewery, name: "testbrewery1")
		  beer1 = FactoryBot.create(:beer, brewery: brewery1)

		  #Toka
		  brewery2 = FactoryBot.create(:brewery, name: "testbrewery2")
		  beer2 = FactoryBot.create(:beer, brewery: brewery2)

		  #Paras
		  brewery3 = FactoryBot.create(:brewery, name: "testbrewery3")
		  beer3 = FactoryBot.create(:beer, brewery: brewery3)

		  FactoryBot.create(:rating, score: 20, beer: beer1, user: user)
		  FactoryBot.create(:rating, score: 25, beer: beer2, user: user)
		  FactoryBot.create(:rating, score: 30, beer: beer3, user: user)

		  expect(user.favorite_brewery).to eq(brewery3.name)
		end
	end
end

def create_beer_with_rating(object, score)
  if object.key?(:style)
	beer = FactoryBot.create(:beer, style: object[:style]) 
  else
	beer = FactoryBot.create(:beer)
  end
  
  FactoryBot.create(:rating, beer: beer, score: score, user: object[:user])
  beer
end
	
def create_beers_with_many_ratings(object, *scores)
  scores.each do |score|
	create_beer_with_rating(object, score)
  end
end
