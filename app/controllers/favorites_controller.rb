class FavoritesController < ApplicationController
  before_action :authorize

  def create
    @favoritable = favorite_params[:favoritable_type].constantize.find(favorite_params[:favoritable_id])

    if current_user.favorites.create(favoritable: @favoritable)
      render :status => :created
    else
      render :nothing => true, :status => :internal_server_error
    end
  end

  def destroy
    @favorite = current_user.favorites.find(params[:id])
    @favoritable = @favorite.favoritable

    if @favorite.destroy
      render :create
    else
      render :nothing => true, :status => :internal_server_error
    end
  end

  def show
    if current_user.favorite_books.count == 0
      redirect_to root_path, alert: "Sorry but you have no books in your Favorites list.
      Click the stars to add books."
    end
  end

  private

  def favorite_params
    params.require(:favorite).permit(:favoritable_id, :favoritable_type)
  end
end
