require 'rails_helper'

RSpec.describe Beer, type: :model do
	describe "with a proper brewery" do
		let(:test_brewery) { Brewery.new name: "test", year: 2000 }
		
		it "with proper name and style is saved" do
			beer = Beer.create name: "testbeer", style: "teststyle", brewery: test_brewery
			expect(beer).to be_valid
			expect(Beer.count).to eq(1)
		end
		
		it "without a name is not saved" do
			beer = Beer.create style: "teststyle", brewery: test_brewery 
			expect(beer).not_to be_valid
			expect(Beer.count).to eq(0)
		end
		
		it "without a style is not saved" do
			beer = Beer.create name: "testbeer", brewery: test_brewery
			expect(beer).not_to be_valid
			expect(Beer.count).to eq(0)
		end
	end
end
