class Movie < ActiveRecord::Base

	ALL_RATINGS = ['G', 'PG', 'PG-13', 'R']

	
	def self.ratings
		ALL_RATINGS
	end
end
