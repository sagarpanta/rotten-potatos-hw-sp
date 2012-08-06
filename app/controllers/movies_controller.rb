class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
	session[:visited_show_action] = 1
  end

  def index
 	#@sr = (params[:ratings].present? ? params[:ratings] : [])
	
	
	if params[:sort].present?
		@selected_sort =  [params[:sort]]
		session[:sort] = @selected_sort
		session[:sort_action] =1
	else
		@selected_sort = nil
		@selected_sort = session[:sort]
		session[:sort_action]  = 0
	end


	
	if params[:ratings].present?
		@selected_ratings = params[:ratings].keys
		session[:ratings] = @selected_ratings
	elsif !params[:ratings].present? and session[:visited_show_action] == 1
		@selected_ratings = []
		@selected_ratings = session[:ratings]
		session[:visited_show_action] = 0
	elsif !params[:ratings].present? and session[:visited_show_action] != 1 and session[:sort_action] == 1
		@selected_ratings = session[:ratings]
		session[:sort_action] = 0
		
	elsif !params[:ratings].present? and session[:visited_show_action] != 1 and session[:sort_action] !=1
		@selected_ratings = []
		session[:ratings] = []
		
	end
	
	
    @movies = Movie.where( {:rating => @selected_ratings}).order(@selected_sort)

	@sort= @selected_sort.present? ? @selected_sort[0]: ''

	@rating = params[:ratings]
	
	@all_ratings = Movie.ratings




  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
