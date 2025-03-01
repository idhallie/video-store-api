class MoviesController < ApplicationController
  
  def index
    if ["title","release_date"].include? params[:sort]
      sort_value = params[:sort]
    else
      sort_value = "id"
    end
    
    movies = Movie.order(sort_value).as_json(only: [:id, :title, :release_date, :available_inventory])
    render json: movies, status: :ok
  end
  
  def show
    movie = Movie.find_by(id: params[:id])
    
    if movie
      render json: movie.as_json(only: [:id, :title, :overview, :release_date, :inventory, :available_inventory])
    else 
      render json: {"errors" => ["not found"]}, status: :not_found
    end
  end
  
  def create
    new_movie = Movie.new(movie_params)
    
    if new_movie.save
      render json: new_movie.as_json(only: [:id]), status: :ok
      return
    else
      render json: { ok: false, errors: new_movie.errors.messages }, status: :bad_request
      return
    end
  end
  
  private
  
  def movie_params
    params.permit(:title, :overview, :release_date, :inventory)
  end
end
