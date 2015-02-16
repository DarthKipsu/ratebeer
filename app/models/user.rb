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

    def self.top_raters(n)
      User.all.sort_by{ |u| -(u.ratings.count||0) }.take(n)
    end

    def favorite_beer
      return nil if ratings.empty?
      ratings.order(score: :desc).limit(1).first.beer
    end

    def favorite_style
      return nil if ratings.empty?
      rated_styles.max_by do |style|
        ratings_for_style = ratings_by_style(style)
        ratings_for_style.map(&:score).sum / ratings_for_style.count
      end
    end

    def favorite_brewery
      return nil if ratings.empty?
      rated_breweries.max_by do |brewery|
        ratings_for_brewery = ratings_by_brewery(brewery)
        ratings_for_brewery.map(&:score).sum / ratings_for_brewery.count
      end
    end

    def rated_styles
      ratings.map { |r| r.beer.style }.uniq
    end

    def ratings_by_style(style)
      ratings.select { |r| r.beer.style.eql? style }
    end

    def rated_breweries
      ratings.map { |r| r.beer.brewery.name }.uniq 
    end

    def ratings_by_brewery(brewery)
      ratings.select { |r| r.beer.brewery.name.eql? brewery }
    end

end
