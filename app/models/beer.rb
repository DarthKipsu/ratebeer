class Beer < ActiveRecord::Base
    belongs_to :brewery
    has_many :ratings

    def average_rating
        sum = ratings.map(&:score).inject(:+)
        sum / ratings.count.to_f
    end

    def to_s
        "#{brewery.name}: #{name}"
    end
end
