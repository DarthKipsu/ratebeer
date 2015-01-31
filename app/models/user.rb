class User < ActiveRecord::Base
    include AverageRating

    has_secure_password

    validates :username, uniqueness: true,
                         length: { in: 3..15 }
    validates :password, length: { minimum: 4 },
                         format: { with: /([A-Z]\D*\d|\d\D*[A-Z])/,
                message: "must contain at least one capital letter and one number" }

    has_many :ratings
    has_many :beers, through: :ratings
    has_many :memberships, dependent: :destroy
    has_many :beer_clubs, through: :memberships
end
