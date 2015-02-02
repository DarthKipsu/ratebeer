require 'rails_helper'

describe Beer do

    it "is not saved without a name" do
        beer = Beer.create style: "Weizen", brewery_id: 1
        expect(beer).not_to be_valid
        expect(Beer.count).to eq(0)
    end

    it "is not saved without a style" do
        beer = Beer.create name: "New beer", brewery_id: 1
        expect(beer).not_to be_valid
        expect(Beer.count).to eq(0)
    end

    it "saves the beer if name and style is set" do
        beer = Beer.create name: "New beer", style: "Weizen"
        expect(beer).to be_valid
        expect(Beer.count).to eq(1)
    end
end
