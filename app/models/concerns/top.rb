module Top
    extend ActiveSupport::Concern

    def self.top(n)
      sorted_by_rating_in_desc_order = Brewery.all.sort_by{ |b| -(b.average_rating||0) }
      sorted_by_rating_in_desc_order.take(n)
    end

end
