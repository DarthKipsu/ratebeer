class Brewery < ActiveRecord::Base
    include AverageRating

    validates :name, presence: true
    validates :year, numericality: { only_integer: true,
                                     greater_than_or_equal_to: 1042 }
    validate :year_not_in_future

    has_many :beers, dependent: :destroy
    has_many :ratings, through: :beers

    def year_not_in_future
        if year.present? && year > Time.now.year
            errors.add(:year, "can't be in the future")
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
end
