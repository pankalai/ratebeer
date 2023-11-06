require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [ Place.new( name: "Oljenkorsi", id: 1 ) ]
    )
    allow(WeatherApi).to receive(:weather_in).with("kumpula").and_return(
      Weather.new( {temperature: "12"})
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if multiple is returned by the API, all are shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [ Place.new( name: "Oljenkorsi", id: 1 ), Place.new( name: "50/50", id: 2 ), Place.new( name: "Kysy Yleisöltä", id: 3 ), Place.new( name: "Kilauta kaverille", id: 4 )  ]
    )
    allow(WeatherApi).to receive(:weather_in).with("kumpula").and_return(
      Weather.new( {temperature: "12"})
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
    expect(page).to have_content "50/50"
    expect(page).to have_content "Kysy Yleisöltä"
    expect(page).to have_content "Kilauta kaverille"
  end

  it "if none is returned by the API, notice text is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      []
    )
    allow(WeatherApi).to receive(:weather_in).with("kumpula").and_return(
      Weather.new( {temperature: "12"})
    )
    
    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "No locations in kumpula"
  end


end