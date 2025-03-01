require "test_helper"

describe MoviesController do
  describe "index" do
    it "responds with JSON and success" do
      get movies_path
      
      expect(response.header['Content-Type']).must_include 'json'
      must_respond_with :success
    end
    
    it "responds with an array of movie hashes" do
      # Act
      get movies_path
      
      # Get the body of the response
      body = JSON.parse(response.body)
      
      # Assert
      expect(body).must_be_instance_of Array
      body.each do |movie|
        expect(movie).must_be_instance_of Hash
        expect(movie.keys.sort).must_equal ["available_inventory", "id", "release_date", "title"]
      end
    end
    
    it "will respond with an empty array when there are no movies" do
      # Arrange
      Movie.destroy_all
      
      # Act
      get movies_path
      body = JSON.parse(response.body)
      
      # Assert
      expect(body).must_be_instance_of Array
      expect(body).must_equal []
    end
    
    describe "optional enhancements" do
      it "sorts by title correctly" do
        get movies_path, params: {sort: "title"}
        
        body = JSON.parse(response.body)
        expect(body).must_be_instance_of Array
        expect(body[0]["title"]).must_equal "Blacksmith Of The Banished"
        expect(body[1]["title"]).must_equal "Savior Of The Curse"
        expect(body[2]["title"]).must_equal "Women Of Destruction"
      end
      
      it "sorts by release date correctly" do
        get movies_path, params: {sort: "release_date"}
        
        body = JSON.parse(response.body)
        expect(body).must_be_instance_of Array
        expect(body[0]["title"]).must_equal "Blacksmith Of The Banished"
        expect(body[1]["title"]).must_equal "Women Of Destruction"
        expect(body[2]["title"]).must_equal "Savior Of The Curse"
      end
      
    end
  end
  
  describe "show" do
    it "will respond with one movie" do
      movie = movies(:blacksmith)
      
      get movie_path(movie.id)
      body = JSON.parse(response.body)
      
      expect(body).must_be_instance_of Hash
      must_respond_with :ok
    end
    
    it "will respond with the correct keys" do
      movie = movies(:blacksmith)
      
      get movie_path(movie.id)
      body = JSON.parse(response.body)
      
      expect(body.keys.sort).must_equal ["available_inventory", "id", "inventory", "overview", "release_date", "title"]
      expect(body["title"]).must_equal "Blacksmith Of The Banished"
    end
    
    it "returns a not found error and status for an invalid movie" do
      get movie_path(-1)
      body = JSON.parse(response.body)
      
      expect(body).must_be_instance_of Hash
      must_respond_with :not_found
    end
  end
  
  describe "create" do
    before do 
      @movie = {
        title: "This is a movie title",
        overview: "This is it's overview",
        release_date: "2019-12-25", 
        inventory: 5
      }
    end
    
    it "can create a new movie" do
      expect {
        post movies_path, params: @movie
      }.must_differ 'Movie.count', 1
      must_respond_with :ok
      body = JSON.parse(response.body)
      expect(body.keys).must_equal (['id'])
    end
    
    it "will respond with bad_request for invalid data" do
      # Arrange - using let from above
      @movie[:title] = nil
      expect {
        # Act
        post movies_path, params: @movie
        # Assert
      }.wont_change "Movie.count"
      must_respond_with :bad_request
      expect(response.header['Content-Type']).must_include 'json'
      body = JSON.parse(response.body)
      expect(body["errors"].keys).must_include "title"
    end
  end
end
