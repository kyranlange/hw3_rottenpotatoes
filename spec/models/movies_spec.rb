
describe Movie do
  describe 'find movies with same director' do
    it 'should call database to find movies' do
      Movie.should_receive(:find_all_by_director)
      m = Movie.new(:title => "Movie1", :id => 1, :director => "bob")
      m.find_similar
    end
  end
end
