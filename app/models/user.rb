class User < ActiveRecord::Base
    include AverageRating

    has_many :ratings
end
