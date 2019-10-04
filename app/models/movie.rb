class Movie < ActiveRecord::Base
    def self.ratings
        # available movie ratings
        ['R', 'PG-13','G','PG'] 
    end    
end