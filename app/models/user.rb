class User < ActiveRecord::Base
  include AverageRating

  has_secure_password

  validates :username, uniqueness: true,
    length: { in: 3..20 }
  validates :password, length: { minimum: 4 },
    format: { with: /([A-Z]\D*\d|\d\D*[A-Z])/,
              message: "must contain at least one capital letter and one number" }

    has_many :ratings, dependent: :destroy
    has_many :beers, through: :ratings
    has_many :memberships, dependent: :destroy
    has_many :beer_clubs, through: :memberships

    def self.github(info)
      user = User.find_by username:info.nickname
      if user.nil?
      password = SecureRandom.base64
      user = User.create!(username: info.nickname,
                          password: password,
                          password_confirmation: password)
      end
      user
    end

    def self.top_raters(n)
      User.all.sort_by{ |u| -(u.ratings.count||0) }.take(n)
    end

    def favorite_beer
      return nil if ratings.empty?
      ratings.order(score: :desc).limit(1).first.beer
    end

    def favorite_style
      favorite :style
    end

    def favorite_brewery
      favorite :brewery
    end

    def favorite(category)
      return nil if ratings.empty?
      rated(category).max_by do |item|
        ratings_by_item = ratings_by(category, item)
        ratings_by_item.map(&:score).sum / ratings_by_item.count
      end
    end

    def rated(category)
      ratings.map { |r| r.beer.send(category) }.uniq
    end

    def ratings_by(category, item)
      ratings.select { |r| r.beer.send(category).eql? item }
    end
end
