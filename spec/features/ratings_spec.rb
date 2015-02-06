require 'rails_helper'

describe "Rating" do
    let!(:brewery) { FactoryGirl.create :brewery, name:'Koff' }
    let!(:beer1) { FactoryGirl.create :beer, name:'Iso 3', brewery:brewery }
    let!(:beer2) { FactoryGirl.create :beer, name:'Karhu', brewery:brewery }
    let!(:user) { FactoryGirl.create :user }
    let!(:user2) { FactoryGirl.create :user, username: 'Salla' }

    before :each do
        sign_in(username: 'Pekka', password: 'Foobar1')
    end

    it "when given, is registered to the beer and user who is signed in" do
        create_rating('Iso 3', '15')
        expect { click_button 'Create Rating' }.to change {
            Rating.count }.from(0).to(1)
        expect(user.ratings.count).to eq(1)
        expect(beer1.ratings.count).to eq(1)
        expect(beer1.average_rating).to eq(15.0)
    end

    it "displays no ratings when there is none" do
        visit ratings_path
        expect(page).to have_content "Number of ratings: 0"
    end

    it "displays ratings count on ratings page" do
        add_ratings(user, 5)
        add_ratings(user2, 4)
        visit ratings_path
        expect(page).to have_content "Number of ratings: 9"
    end

    it "displays users ratings on users page" do
        add_ratings(user, 3)
        visit user_path(user)
        expect(page).to have_content "Has made 3 ratings"
    end

    it "does not display other users ratings on users page" do
        add_ratings(user, 2)
        add_ratings(user2, 5)
        visit user_path(user)
        expect(page).to have_content "Has made 2 ratings"
    end

    it "removes ratings from the system when deleted" do
        FactoryGirl.create :rating, beer:beer2, user:user
        add_ratings(user, 2)
        visit user_path(user)
        expect {
            page.find('li', text:'Karhu').click_link('delete')
        }.to change { user.ratings.count }.by(-1)
        expect(Rating.count).to equal(2)
    end
end

def create_rating(beer_name, score)
    visit new_rating_path
    select beer_name, from: 'rating[beer_id]'
    fill_in 'rating[score]', with: score
end

def add_ratings(user, n)
    n.times { FactoryGirl.create :rating, beer:beer1, user:user }
end
