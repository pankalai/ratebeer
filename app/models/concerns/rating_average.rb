module RatingAverage
    extend ActiveSupport::Concern
 
    def average_rating
        if self.ratings.count > 0
            self.ratings.average(:score).round(2)
        else
            0
        end
    end
end