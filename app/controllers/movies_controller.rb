class MoviesController < ApplicationController
  helper:all
  
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #Find the all possible ratings of the movies
    @all_ratings = Movie.listRatings
    
    #If ratings are passed as parameters then form the ratings key with those
    if params[:ratings]
      @def_ratings = params[:ratings]
    #If ratings not in params pick the ratings filter from session params
    elsif session[:ratings]
      @def_ratings = session[:ratings]
    #If ratings in session params are nill then choose all ratings
    else
      @def_ratings = Hash[@all_ratings.collect{|item| [item, '1']}]
    end
    
    #If sort id is passed in params then set sort_key to that value else choose from session params
    if params[:sort_id]
      sort_key = params[:sort_id]
    else
      sort_key = session[:sort_id]
    end
    
    @title_hilite = ''
    @date_hilite = ''
    if sort_key == 'title'
      #@movies = Movie.ascorder('title')
      @title_hilite = 'hilite'
    elsif sort_key == 'release_date'
      #@movies = Movie.ascorder('release_date')
      @date_hilite = 'hilite'
    end
    
    session[:ratings] = @def_ratings
    session[:sort_id] = sort_key
    
    @movies = Movie.get_Rated_Movies(@def_ratings.keys(), sort_key)
    
  end
  
  def new
    # default: render 'new' template
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

end