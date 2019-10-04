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
    @all_ratings = Movie.list_Ratings
    
    if parm[:ratings]
      @def_rat = parm[:ratings]
    elsif params[:ratings]
      @def_rat = params[:ratings] #choose params ratings 
   
    
    #choose all ratings when null
    else
      @def_rat = Hash[@all_ratings.collect{|item| [item, '1']}]
    end
    
    
    if params[:sort_id]
      key_sorted = params[:sort_id]
    else
      key_sorted = parm[:sort_id] #passed sort_id n params, key_sorted is set to that value 
      #else choose from parm params
    end
    
    @date_hilite = ''
    @title_hilite = ''
    
   if key_sorted == 'release_date'
      @date_hilite = 'hilite' 
    elsif key_sorted == 'title'
     
      @title_hilite = 'hilite'
   
    end
    
   parm[:ratings] = @def_rat
    parm[:sort_id] = key_sorted
    
    @movies = Movie.get_Rated_Movies(@def_rat.keys(), key_sorted)
    
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