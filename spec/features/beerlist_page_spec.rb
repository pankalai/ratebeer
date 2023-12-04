require 'rails_helper'

describe "Beerlist page" do
  before :all do
    Capybara.register_driver :chrome  do |app|
        Capybara::Selenium::Driver.new app, browser: :chrome,
          options: Selenium::WebDriver::Chrome::Options.new(args: %w[headless disable-gpu])
        
    end
    Capybara.javascript_driver = :chrome
    WebMock.allow_net_connect!
    #WebMock.disable_net_connect!(allow_localhost: true)
  end

#   before :all do
#     Capybara.register_driver :selenium do |app|
#       Capybara::Selenium::Driver.new(app, :browser => :chrome)
#     end
#     WebMock.allow_net_connect!
#   end

  before :each do
    @brewery1 = FactoryBot.create(:brewery, name: "Koff")
    @brewery2 = FactoryBot.create(:brewery, name: "Schlenkerla")
    @brewery3 = FactoryBot.create(:brewery, name: "Ayinger")
    @style1 = Style.create name: "Lager"
    @style2 = Style.create name: "Rauchbier"
    @style3 = Style.create name: "Weizen"
    @beer1 = FactoryBot.create(:beer, name: "Nikolai", brewery: @brewery1, style:@style1)
    @beer2 = FactoryBot.create(:beer, name: "Fastenbier", brewery:@brewery2, style:@style2)
    @beer3 = FactoryBot.create(:beer, name: "Lechte Weisse", brewery:@brewery3, style:@style3)
  end

  it "shows the known beers", js:true do
    visit beerlist_path
    tr = find('#beertable').all('.tablerow')
    expect(tr[0].first('td')).to have_content "Fastenbier"
    expect(tr[1].first('td')).to have_content "Lechte Weisse"
    expect(tr[2].first('td')).to have_content "Nikolai"
    #print page.html
  end

  it "sort by style", js:true do
    visit beerlist_path
    find('#style').click
    tr = find('#beertable').all('.tablerow')
    expect(tr[0].all('td')[1]).to have_content "Lager"
    expect(tr[1].all('td')[1]).to have_content "Rauchbier"
    expect(tr[2].all('td')[1]).to have_content "Weizen"
  end

  it "sort by brewery", js:true do
    visit beerlist_path
    find('#brewery').click
    tr = find('#beertable').all('.tablerow')
    expect(tr[0].all('td')[2]).to have_content "Ayinger"
    expect(tr[1].all('td')[2]).to have_content "Koff"
    expect(tr[2].all('td')[2]).to have_content "Schlenkerla"
  end
end
