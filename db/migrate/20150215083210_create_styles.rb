class CreateStyles < ActiveRecord::Migration
  def change
    create_table :styles do |t|
      t.string :name
      t.text :description

      t.timestamps null: false
    end

    rename_column :beers, :style, :old_style
    add_column :beers, :style_id, :integer

    Style.create :name => 'Sahti', :description => 'Sahti is a traditional beer from Finland made from a variety of grains, malted and unmalted, including barley, rye, wheat, and oats.'
    Style.create :name => 'Pale Ale', :description => 'Pale ale is a beer made by warm fermentation using predominantly pale malt.'
    Style.create :name => 'Brown Ale', :description => 'Brown ales tend to be lightly hopped, and fairly mildly flavoured, often with a nutty taste.'
    Style.create :name => 'IPA', :description => 'India Pale Ale (IPA) is a hoppy beer style within the broader category of pale ale.'
    Style.create :name => 'Lager', :description => 'Lager is a type of beer that is fermented and conditioned at low temperatures. Pale lager is the most widely consumed and commercially available style of beer in the world.'
    Style.create :name => 'Porter', :description => 'Porter is a dark style of beer developed in London from well-hopped beers made from brown malt.'
    Style.create :name => 'Weizen', :description => 'Weizen, aka wheat beer is a style of beer brewed with a large proportion of wheat malt'
    Style.create :name => 'Stout', :description => 'Stout is a dark beer made using roasted malt or roasted barley, hops, water and yeast.'
    Style.create :name => 'lowalcohol', :description => 'Low-alcohol beer starts out as regular alcoholic beer, which is then cooked in order to evaporate the alcohol.'

    for beer in Beer.all
        beer.update_attribute 'style_id', Style.find_by_name(beer.old_style).id
    end

    remove_column :beers, :old_style
  end
end
