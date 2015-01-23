module AverageRating
    extend ActiveSupport::Concern

    def average_rating
        sum = ratings.map(&:score).inject(:+)
        sum / ratings.count.to_f
    end

end
