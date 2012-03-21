class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  
  def find_similar
    Movie.find_by_director(self.director)
  end
end
