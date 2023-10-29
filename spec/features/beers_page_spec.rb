require 'rails_helper'

describe "Beer page" do
	before :each do
		FactoryBot.create :user
		sign_in(username: "Pekka", password: "Foobar1")
		FactoryBot.create :brewery
		visit new_beer_path
	end
	
	it "allows to add a valid beer" do
		fill_in('beer_name', with: 'Brian')
		select('IPA', from: 'beer[style]')
		select('anonymous', from: 'beer[brewery_id]')
		
		expect{
			click_button('Create Beer')
		}.to change{Beer.count}.by(1)
	end
	
	it "is redirected back to new beer form if invalid beer name given" do
		fill_in('beer_name', with: '')
		select('IPA', from: 'beer[style]')
		select('anonymous', from: 'beer[brewery_id]')
		
		expect{
			click_button('Create Beer')
		}.to change{Beer.count}.by(0)
		
		expect(page).to have_content "Name is too short"
	end
end