require 'rails_helper'

describe User do
    it "has the username set correctly" do
        user = User.new username: "Pekka"
        expect(user.username).to eq("Pekka")
    end 

    it "is not saved without a password" do
        user = User.new username: "Pekka"
        expect(user).not_to be_valid
        expect(User.count).to eq(0)
    end

    it "is not saved with two short password" do
        user = User.create username: "Pekka",
                           password: "Ab1",
                           password_confirmation: "Ab1"
        expect(user).not_to be_valid
        expect(User.count).to eq(0)
    end

    it "is not saved with a password with only letters" do
        user = User.create username: "Pekka",
                           password: "PitkaSalasana",
                           password_confirmation: "PitkaSalasana"
        expect(user).not_to be_valid
        expect(User.count).to eq(0)
    end

    describe "with a proper password" do
        let!(:user) { FactoryGirl.create(:user) }

        it "is saved" do
            expect(user).to be_valid
            expect(User.count).to eq(1)
        end

        it "and with two ratings, has the correct average rating" do
            user.ratings << FactoryGirl.create(:rating)
            user.ratings << FactoryGirl.create(:rating2)

            expect(user.ratings.count).to eq(2)
            expect(user.average_rating).to eq(15.0)
        end
    end

    describe "with ratings" do
        let!(:user) { FactoryGirl.create(:user) }

        it "has method for determining the favorite_beer" do
            expect(user).to respond_to(:favorite_beer)
        end

        it "does not have a favorite beer without ratings" do
            expect(user.favorite_beer).to eq(nil)
        end

        it "has fav beer which is the only rated if only one rating" do
            beer = FactoryGirl.create(:beer)
            rating = FactoryGirl.create(:rating, beer:beer, user:user)
            expect(user.favorite_beer).to eq(beer)
        end

        it "has fav beer which is the one with highest rating if several rated" do
            create_beers_with_ratings(9, 8, 13, 19, 21, "Lager", user)
            best = create_beer_with_rating(25, "Lager", user)
            
            expect(user.favorite_beer).to eq(best)
        end

        it "has method for determining the favorite_style" do
            expect(user).to respond_to(:favorite_style)
        end

        it "does not have a favorite style without ratings" do
            expect(user.favorite_style).to eq(nil)
        end

        it "has favorite style which is the only rated if only one rating" do
            beer = FactoryGirl.create(:beer)
            rating = FactoryGirl.create(:rating, beer:beer, user:user)
            expect(user.favorite_style).to eq("Lager")
        end

        it "has favorite style based on rating averages" do
            create_beers_with_ratings(9, 8, "Lager", user)
            create_beers_with_ratings(23, 24, "Porter", user)
            create_beers_with_ratings(25, 13, 22, "Pale Ale", user)
            
            expect(user.favorite_style).to eq("Porter")
        end

        it "has method for determining the favorite_brewery" do
            expect(user).to respond_to(:favorite_brewery)
        end

        it "does not have a favorite brewery without ratings" do
            expect(user.favorite_brewery).to eq(nil)
        end

        it "has favorite brewery which is the only rated if only one rating" do
            brewery = create_beer_with_rating_and_brewery(20, "Fav", user)
            expect(user.favorite_brewery).to eq("Fav")
        end

        it "has favorite brewery based on rating averages" do
            crete_brewery_ratings(20, 25, 30, "Fav Brewery", user)
            crete_brewery_ratings(20, 22, 26, "Second best", user)
            crete_brewery_ratings(1, 2, 39, "Single good", user)
            
            expect(user.favorite_brewery).to eq("Fav Brewery")
        end

    end

end

def create_beers_with_ratings(*scores, style, user)
    scores.each do |score|
        create_beer_with_rating(score, style, user)
    end
end

def create_beer_with_rating(score, style, user)
    beer = FactoryGirl.create(:beer, style:style)
    FactoryGirl.create(:rating, score:score, beer:beer, user:user)
    beer
end

def crete_brewery_ratings(*scores, brewery_name, user)
    scores.each do |score|
        create_beer_with_rating_and_brewery(score, brewery_name, user)
    end
end

def create_beer_with_rating_and_brewery(score, brewery_name, user)
    brewery = FactoryGirl.create(:brewery, name:brewery_name)
    beer = FactoryGirl.create(:beer, brewery:brewery)
    FactoryGirl.create(:rating, score:score, beer:beer, user:user)
    beer
end
