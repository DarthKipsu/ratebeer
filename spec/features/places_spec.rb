require 'rails_helper'

describe "Places" do
    it "if one is returned by the API, it is shown at the page" do
        add_places('Oljenkorsi', 'Kumpula')
        visit_places('Kumpula')
        expect(page).to have_content "Oljenkorsi"
    end 

    it "if several is returned by the API, all are shown at the page" do
        add_places('Oljenkorsi', 'Kumpulan salakapakka', 'Baari 5', 'Kumpula')
        visit_places('Kumpula')
        expect(page).to have_content "Oljenkorsi"
        expect(page).to have_content "Kumpulan salakapakka"
        expect(page).to have_content "Baari 5"
    end 

    it "if none are returned by the API, a fash message is shown at the page" do
        add_places('Kumpula')
        visit_places('Kumpula')
        expect(page).to have_content "No locations in Kumpula"
    end 
end

def add_places(*places, query)
    places_vector = []
    places.each do |place|
        places_vector << Place.new( name: place, id: 1)
    end
    allow(BeermappingApi).to receive(:places_in).with(query).and_return(places_vector)
end

def visit_places(city)
        visit places_path
        fill_in('city', with: city)
        click_button "Search"
end
