require 'rails_helper'
include Helpers

describe "Rating" do
  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
  let!(:style) { FactoryBot.create :style}
  let!(:beer1) { FactoryBot.create :beer, name: "Iso 3", brewery:brewery, style:style }
  let!(:beer2) { FactoryBot.create :beer, name: "Karhu", brewery:brewery, style:style }
  let!(:user) { FactoryBot.create :user }

  before :each do
    sign_in(username: "Pekka", password: "Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('Iso 3', from: 'rating[beer_id]')
    fill_in('rating[score]', with: '15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end
  
  it "added ratings are shown in page" do
    FactoryBot.create :rating, beer:beer1, user: user
    FactoryBot.create :rating, beer:beer2, user: user
    
    visit ratings_path
    expect(Rating.count).to be(2)
    expect(page).to have_content 'Number of ratings: 2'
    expect(page).to have_content 'Iso 3'
    expect(page).to have_content 'Karhu'
  end
  
  it "user's ratings are shown in user's page" do
    FactoryBot.create :rating, score: 15, beer: beer1, user: user
    
    user2 = FactoryBot.create :user, username: "Pekka2", password: "Foobar2", password_confirmation: "Foobar2"
    FactoryBot.create :rating, score: 25, beer: beer2, user: user2
    
    visit user_path(user)
    expect(page).to have_content 'Has made 1 rating'
    expect(page).to have_content 'Iso 3'
    expect(page).to have_content '15'
  end
  
  it "destroyed rating is deleted from database" do
    FactoryBot.create :rating, score: 15, beer: beer1, user: user
    rat = FactoryBot.create :rating, score: 15, beer: beer2, user: user
    visit user_path(user)
      expect{
        find("a[href='#{rating_path(rat)}']").click
      }.to change{Rating.count}.from(2).to(1)
    expect(page).to have_content 'Has made 1 rating'
    expect(page).to have_content 'Iso 3'
  end
  
  it "favorite beer style and brewery are shown" do
    brewery2 = FactoryBot.create :brewery, name: "Sinebrychoff"
    style2 = FactoryBot.create :style, name: "Vehnä"
    beer3 = FactoryBot.create :beer, name: "Iso 2", style: style2, brewery:brewery
    beer4 = FactoryBot.create :beer, name: "Iso 4", brewery:brewery2, style:style 
    
    FactoryBot.create :rating, score: 10, beer: beer1, user: user
    FactoryBot.create :rating, score: 10, beer: beer2, user: user
    FactoryBot.create :rating, score: 30, beer: beer3, user: user
    FactoryBot.create :rating, score: 35, beer: beer4, user: user

    visit user_path(user)
    expect(page).to have_content 'Favorite style: Vehnä'
    expect(page).to have_content 'Favorite brewery: Sinebrychoff'
  end
end