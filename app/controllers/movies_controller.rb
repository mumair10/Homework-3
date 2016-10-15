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
 
    @all_ratings=Movie.get_all_ratings
=begin    
    
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
=end  
    session[:ratings] = params[:ratings] unless params[:ratings].nil?
    session[:sort_param] = params[:sort_param] unless params[:sort_param].nil?
    
    if params[:sort_param] == 'title'
      @title_header = 'hilite'
    elsif params[:sort_param] == 'release_date'
      @release_header= 'hilite'
    end

    if (params[:ratings].nil? && !session[:ratings].nil?) || (params[:sort_param].nil? && !session[:sort_param].nil?)
      flash.keep
      redirect_to movies_path("ratings" => session[:ratings], "sort_param" => session[:sort_param])
    elsif !params[:ratings].nil? || !params[:sort_param].nil?
      if !params[:ratings].nil?
        array_ratings = params[:ratings].keys
        return @movies = Movie.where(rating: array_ratings).order(session[:sort_param])
      else
        if params[:sort_param] == 'title'
          @title_header = 'hilite'
        elsif params[:sort_param] == 'release_date'
          @release_header= 'hilite'
        end
        return @movies = Movie.all.order(session[:sort_param])
      end
    elsif !session[:ratings].nil? || !session[:sort_param].nil?
      redirect_to movies_path("ratings" => session[:ratings], "order" => session[:sort_param])
    else
      return @movies = Movie.all
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
