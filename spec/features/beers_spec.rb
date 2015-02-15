require 'rails_helper'

describe "Beer" do
    let!(:brewery) { FactoryGirl.create :brewery, name:'Koff' }
    let!(:style) { FactoryGirl.create :style }
    let!(:user) { FactoryGirl.create :user }

    before :each do
        sign_in(username: 'Pekka', password: 'Foobar1')
    end

    it "when added with correct name is registered to the system" do
        create_new_beer('Karhu', 'Lager', 'Koff')
        expect { click_button 'Create Beer' }.to change { 
            Beer.count }.from(0).to(1)
        expect(current_path).to eq(beers_path)
        expect(page).to have_content 'Karhu'
    end

    it "does not get reqistered with an empty name field" do
        create_new_beer('', 'Lager', 'Koff')
        click_button 'Create Beer'

        expect(Beer.count).to equal(0)
        expect(current_path).to eq(beers_path)
        expect(page).to have_content "New Beer"
        expect(page).to have_content "Name can't be blank"
    end
end

def create_new_beer(name, style, brewery_name)
    visit new_beer_path
    fill_in 'beer_name', with: name
    select style, from: 'beer[style_id]'
    select brewery_name, from: 'beer[brewery_id]'
end
