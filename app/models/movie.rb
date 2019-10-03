class Movie < ActiveRecord::Base
    def self.ascorder(key)
        #puts @movies
        @movies = Movie.order(key)
        return @movies
    end
    
    def self.listRatings
        list = Movie.uniq.pluck(:rating)
        return list
    end
    
    # Get the movies in sorted oreder with ratings filter
    def self.get_Rated_Movies(list, sort_key = nil)
        @movies = Movie.where(rating: list).order(sort_key)
    end 
end