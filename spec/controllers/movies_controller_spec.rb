require 'spec_helper'

describe MoviesController do
  describe 'show all movies' do
    it 'should return movies' do
      get :index
    end
    
    it 'should sort by title' do
      get :index, :sort => 'title'
    end
    
    it 'should sort by release date' do
      get :index, :sort => 'release_date'
    end
    
    it 'should filter by ratings' do
      ratings = {'R'=>'R'}
      get :index, :ratings => ratings 
    end
  end
  
  describe 'show a movie' do
    it 'should show a movie' do
      @m = mock('movie1')
      Movie.should_receive(:find).with("1").and_return(@m)
      get :show, :id => 1
    end
  end
  
  describe 'create a movie' do
    it 'should create a movie' do
      @m = mock("Movie1")
      @m.stub(:title).and_return("Movie1")
      Movie.should_receive(:create!).and_return(@m)
      post :create, :movie => @m
    end
  end
  
  describe 'update a movie' do
    it 'should update a movie' do
      @m = mock('movie1')
      @m.stub(:title).and_return("Movie1")
      Movie.should_receive(:find).with("1").and_return(@m)
      @m.should_receive(:update_attributes!)
      put :update, :id => 1, :movie => @m
    end
  end
  
  describe 'destroy a movie' do
    it 'should destroy a movie' do
      @m = mock('movie1')
      Movie.should_receive(:find).with("1").and_return(@m)
      @m.should_receive(:destroy)
      @m.stub(:title).and_return("Movie1")
      delete :destroy, :id => 1
    end
  end
  
  describe 'find similar movies' do
    before :each do
      @m = mock('movie1')
      @m.stub(:director).and_return("bob")
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
    
    it 'should warn if no director' do
      Movie.stub(:find).and_return(@m)
      @m.stub(:director).and_return(nil)
      @m.stub(:title).and_return("movie1")
      @m.stub(:find_similar)
      get :similar, :id => 1
    end
  end
end
