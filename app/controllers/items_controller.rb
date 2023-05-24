class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :index_not_found_response
  rescue_from NoMethodError, with: :index_not_found_response

  def index
    if params[:user_id]
      user = User.find_by!(id: params[:user_id])
      if params[:id]
        items = user.items.find_by!(id: params[:id])
      else
        items = user.items
      end
    else
      items = Item.all
    end
    render json: items, include: :user
  end

  def show
    if params[:user_id]
      user = User.find_by!(id: params[:user_id])
      item = Item.find_by!(id: params[:id])
      
    elsif params[:id]
      item = Item.find(id: params[:id])
    else
      item = Item.all
    end
    if !item
      index_not_found_response
    end
    render json: item, include: :user
  end

  def create
    user = User.find_by!(id: params[:user_id])
    item = user.items.create!(item_params)
    render json: item, status: :created
  end

  def index_not_found_response
    render json: { error: "The requested resource could not be found" }, status: :not_found
  end

  def item_params
    params.permit(:name, :description, :price)
  end
end
