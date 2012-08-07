require 'Iconv'

class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
	session[:visited_show_action] = 1
  end

  def index

 
 
   	#@sr = (params[:ratings].present? ? params[:ratings] : [])
	@all_ratings = Movie.ratings
	redirect = false
	

	if params[:ratings].present?
		@selected_ratings = params[:ratings].keys
		session[:ratings] = @selected_ratings
		session[:currently_selected] = params[:ratings]
	else
		@selected_ratings = nil
		if  session[:ratings] != nil && params[:commit] == nil
			redirect = true
		else
			session[:ratings] = nil
			session[:currently_selected] = nil
		end
	end
	
	if ['title' , 'release_date'].include? params[:sort]
		@movies = Movie.where({:rating=>session[:ratings]}).order(params[:sort])
		@sort_by = params[:sort]
		session[:sort] = @sort_by
	else 
		#watch for this line
		@movies = Movie.where({:rating => @selected_ratings})
		@sort_by = nil
		unless session[:sort].nil?
			@sort_by = session[:sort]
			redirect = true
		end
	end
	


	#session[:ratings] = nil
	#session[:sort] = nil
	#session[:currently_selected] = nil
	@sort= @sort_by.present? ? @sort_by: nil

	@rating = params[:ratings].nil? ? [] : params[:ratings]
	
	
	if redirect
		redirect_to movies_path({:ratings => session[:currently_selected],:sort=>@sort_by})
	end

  end

  def new
    # default: render 'new' template
  end

  def create
	session[:visited_show_action] = 1
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
	session[:visited_show_action] = 1
    @movie = Movie.find params[:id]
  end

  def update
	session[:visited_show_action] = 1
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
