module AverageRating
    extend ActiveSupport::Concern

    def average_rating
        return 0 if ratings.empty?
        sum = ratings.map(&:score).sum
        sum / ratings.count.to_f
    end

end
