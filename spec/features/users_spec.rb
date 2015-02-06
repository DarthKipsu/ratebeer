require 'rails_helper'

describe "User" do
    let!(:user) { FactoryGirl.create(:user) }

    describe "who has signed up" do
        it "can signin with right credentials" do
            sign_in(username: 'Pekka', password: 'Foobar1')
            expect(page).to have_content 'Welcome back!'
            expect(page).to have_content 'Pekka'
        end

        it "is redirected back to signin form if wrong credentials given" do
            sign_in(username: 'Pekka', password: 'wrong')
            expect(current_path).to eq(signin_path)
            expect(page).to have_content 'Username and/or password mismatch'
        end

        it "does not have favorite style or brewery if has no ratings" do
            sign_in(username: 'Pekka', password: 'Foobar1')
            expect(page).not_to have_content 'Favorite beer style is'
            expect(page).not_to have_content 'and brewery'
        end

        it "has favorite beer style and brewery after at least one rating" do
            beer = FactoryGirl.create(:beer)
            FactoryGirl.create(:rating, user:user, beer:beer)
            sign_in(username: 'Pekka', password: 'Foobar1')
            expect(page).to have_content 'Favorite beer style is Lager'
            expect(page).to have_content 'and brewery anonymous'
        end
    end

    describe "who has not signed up" do
        it "is added to the system when signing up" do
            visit signup_path
            fill_in('user_username', with:'Brian')
            fill_in('user_password', with:'Secret55')
            fill_in('user_password_confirmation', with:'Secret55')

            expect { click_button 'Create User' }.to change { User.count }.by(1)
        end
    end
end
