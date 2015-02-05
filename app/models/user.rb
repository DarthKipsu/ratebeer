class User < ActiveRecord::Base
    include AverageRating

    has_secure_password

    validates :username, uniqueness: true,
                         length: { in: 3..15 }
    validates :password, length: { minimum: 4 },
                         format: { with: /([A-Z]\D*\d|\d\D*[A-Z])/,
                message: "must contain at least one capital letter and one number" }

    has_many :ratings, dependent: :destroy
    has_many :beers, through: :ratings
    has_many :memberships, dependent: :destroy
    has_many :beer_clubs, through: :memberships

    def favorite_beer
        return nil if ratings.empty?
        ratings.order(score: :desc).limit(1).first.beer
    end

    def favorite_style
        return nil if ratings.empty?
        rated_styles.max_by do |style|
            ratings_for_style = ratings_for(style)
            ratings_for_style.map(&:score).sum / ratings_for_style.count
        end
    end

    def rated_styles
        ratings.map { |r| r.beer.style }.uniq
    end

    def ratings_for(style)
        ratings.select { |r| r.beer.style.eql? style }
    end

end
