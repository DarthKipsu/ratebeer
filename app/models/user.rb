class User < ActiveRecord::Base
    include AverageRating

    validates :username, uniqueness: true,
                         length: { in: 3..15 }

    has_many :ratings
    has_many :beers, through: :ratings
end
