class Beer < ActiveRecord::Base
    include AverageRating

    validates :name, presence: true
    validates :style_id, presence: true

    belongs_to :brewery, touch: true
    belongs_to :style
    has_many :ratings, dependent: :destroy
    has_many :raters, -> {u uniq }, through: :ratings, source: :user

    def to_s
        "#{brewery.name}: #{name}"
    end

    def self.top(n)
      Beer.all.sort_by{ |b| -(b.average_rating||0) }.take(n)
    end
end
