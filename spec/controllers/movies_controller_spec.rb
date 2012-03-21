require 'spec_helper'

describe MoviesController do
  describe 'find similar movies' do
    before :each do
      @m = mock('movie1')
      @n = mock('movie2')
      @fakeresults = [@m, @n]
    end
    
    it 'should call the Model method to find similar movies with the same director' do
      Movie.should_receive(:find).and_return(@m)
      @m.should_receive(:find_similar).and_return(@fakeresults)
      get :similar, :id => 1
    end
    
    it 'should select the similar movies template for rendering' do
      Movie.stub(:find).and_return(@m)
      @m.stub(:find_similar).and_return(@fakeresults)
      get :similar, :id => 1
      response.should render_template('similar')
    end
      
    it 'should make the similar movies available to that template' do
      Movie.stub(:find).and_return(@m)
      @m.stub(:find_similar).and_return(@fakeresults)
      get :similar, :id => 1
      assigns(:movies).should == @fakeresults
    end
  end
end
