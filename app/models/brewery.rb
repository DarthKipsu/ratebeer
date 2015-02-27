class Brewery < ActiveRecord::Base
  include AverageRating

  validates :name, presence: true
  validates :year, numericality: { only_integer: true,
                                   greater_than_or_equal_to: 1042,
                                   less_than_or_equal_to: ->(_) { Time.now.year} }

  scope :active, -> { where active:true }
  scope :retired, -> { where active:[nil,false] }

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  def self.ordered(order, prev_session_order)
    active = Brewery.active
    retired = Brewery.retired

    case order
      when 'name' then
        active = active.sort_by{ |b| b.name.downcase }
        retired = retired.sort_by{ |b| b.name.downcase }
      when 'year' then
        active = active.sort_by{ |b| b.year }
        retired = retired.sort_by{ |b| b.year }
    end

    if order.eql? prev_session_order then
      { active: active.reverse, retired: retired.reverse, session: nil }
    else
      { active: active, retired: retired, session: order }
    end
  end

  def print_report
    puts name
    puts "established at year #{year}"
    puts "number of beers #{beers.count}"
  end

  def restart
    self.year = 2015
    puts "changed year to #{year}"
  end

  def self.top(n)
    Brewery.all.sort_by{ |b| -(b.average_rating||0) }.take(n)
  end
end
