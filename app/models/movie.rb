class Movie < ActiveRecord::Base
    
    def self.get_all_ratings
 	all_ratings = []
		self.select(:rating).group(:rating).each do |mo|
			all_ratings << mo.rating
		end
		return all_ratings
  end
    
end
