class MoviesController < ApplicationController
  
  helper_method :chosen_rating?

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
  end

  def new
    # default: render 'new' template
  end
  
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
  
  
  def index
   # @movies = Movie.all
    @all_ratings=Movie.get_all_ratings
    
    
    if params[:sort_param] == 'title'
      @movies = Movie.order(params[:sort_param])
      @title_header = 'hilite'
      return
    elsif params[:sort_param] == 'release_date'
      @movies = Movie.order(params[:sort_param])
      @release_header= 'hilite'
      return
    end
    
    #session[:ratings] = params[:ratings] unless params[:ratings].nil?
    #session[:order] = params[:order] unless params[:order].nil
      
    if !params[:ratings].nil? 
        array_ratings = params[:ratings].keys
        @movies = Movie.where(rating: array_ratings).order(params[:sort_param])
      
    else  
      @movies=Movie.all
      
    end
    
    
    
  end
  
  
  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  def chosen_rating?(rating)
    chosen_ratings = params[:ratings]
    return true if chosen_ratings.nil?
    chosen_ratings.include? rating
  end


end
