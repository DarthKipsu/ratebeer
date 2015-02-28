require 'rails_helper'

describe "Beerlist page" do
  let!(:user) { FactoryGirl.create :user }

  before :all do
    self.use_transactional_fixtures = false
    WebMock.disable_net_connect!(allow_localhost:true)
  end

  before :each do
    sign_in(username: 'Pekka', password: 'Foobar1')
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
    @brewery1 = FactoryGirl.create(:brewery, name:"Koff")
    @brewery2 = FactoryGirl.create(:brewery, name:"Schlenkerla")
    @brewery3 = FactoryGirl.create(:brewery, name:"Ayinger")
    @style1 = Style.create name:"Lager"
    @style2 = Style.create name:"Rauchbier"
    @style3 = Style.create name:"Weizen"
    @beer1 = FactoryGirl.create(:beer, name:"Nikolai", brewery: @brewery1, style:@style1)
    @beer2 = FactoryGirl.create(:beer, name:"Fastenbier", brewery:@brewery2, style:@style2)
    @beer3 = FactoryGirl.create(:beer, name:"Lechte Weisse", brewery:@brewery3, style:@style3)
  end

  after :each do
    DatabaseCleaner.clean
  end

  after :all do
    self.use_transactional_fixtures = true
  end

  it "shows a known beer", js:true do
    visit beerlist_path
    expect(page).to have_content "Nikolai"
  end

  it "lists beers ordered by name", js:true do
    visit beerlist_path
    expect(find('table').find('tr:nth-child(2)')).to have_content "Fastenbier"
    expect(find('table').find('tr:nth-child(3)')).to have_content "Lechte Weisse"
    expect(find('table').find('tr:nth-child(4)')).to have_content "Nikolai"
  end

  it "lists beers ordered by name in reversed order", js:true do
    visit beerlist_path
    click_link 'Name'
    click_link 'Name'
    expect(find('table').find('tr:nth-child(2)')).to have_content "Nikolai"
    expect(find('table').find('tr:nth-child(3)')).to have_content "Lechte Weisse"
    expect(find('table').find('tr:nth-child(4)')).to have_content "Fastenbier"
  end

  it "can be reordered to display beers by style", js:true do
    visit beerlist_path
    click_link 'Style'
    expect(find('table').find('tr:nth-child(2)')).to have_content "Lager"
    expect(find('table').find('tr:nth-child(3)')).to have_content "Rauchbier"
    expect(find('table').find('tr:nth-child(4)')).to have_content "Weizen"
  end

  it "can be reordered to display beers by style in reversed order", js:true do
    visit beerlist_path
    click_link 'Style'
    click_link 'Style'
    expect(find('table').find('tr:nth-child(2)')).to have_content "Weizen"
    expect(find('table').find('tr:nth-child(3)')).to have_content "Rauchbier"
    expect(find('table').find('tr:nth-child(4)')).to have_content "Lager"
  end

  it "can be reordered to display beers by brewery", js:true do
    visit beerlist_path
    click_link 'Brewery'
    expect(find('table').find('tr:nth-child(2)')).to have_content "Ayinger"
    expect(find('table').find('tr:nth-child(3)')).to have_content "Koff"
    expect(find('table').find('tr:nth-child(4)')).to have_content "Schlenkerla"
  end

  it "can be reordered to display beers by brewery in reversed order", js:true do
    visit beerlist_path
    click_link 'Brewery'
    click_link 'Brewery'
    expect(find('table').find('tr:nth-child(2)')).to have_content "Schlenkerla"
    expect(find('table').find('tr:nth-child(3)')).to have_content "Koff"
    expect(find('table').find('tr:nth-child(4)')).to have_content "Ayinger"
  end
end
