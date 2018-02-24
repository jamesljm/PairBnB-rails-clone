class ListingsController < ApplicationController
  before_action :get_listing_with_id, only: [:show, :edit, :update]
  
  def index
    @listings = Listing.paginate(:page => params[:page], :per_page => 20)
  end
  
  def show
    get_listing_with_id
  end

  def edit
    # check role
    if current_user.superadmin? || Listing.find(params[:id]).user_id == current_user.id
      get_listing_with_id
    else
    # redirect if not admin or user
      redirect_to root_path
      flash[:success] = "Not enough token"
    end
  end

  def update
    if params["listing"]["amenities"] == nil
      params["listing"]["amenities"] = []
    end
    @listing = current_user.listings.find(params[:id])
    if @listing.update(listing_params)
      redirect_to listing_path(params[:id])
      flash[:success] = "Update complete"
    end
  end

  def search
  end

  def new
  end

  def destroy
    if current_user.superadmin? || Listing.find(params[:id]).user_id == current_user.id
      @listing = Listing.find(params[:id]).delete
    else
    # redirect if not admin or user
      flash[:success] = "Not enough token"
      redirect_to sign_in_path
    end
  end

private
  # Getter
  def get_listing_with_id
    @listing = Listing.find(params[:id])
  end

  # Listing's strong parameters
  def listing_params
    params.require(:listing).permit(# basic info
                                    :name, 
                                    :place_type, 
                                    :property_type, 
                                    # housing info
                                    :room_number, 
                                    :bed_number, 
                                    :guest_number, 
                                    :kitchen, 
                                    # location
                                    :country, 
                                    :state, 
                                    :city, 
                                    :zipcode, 
                                    :address, 
                                    # pricing
                                    :price, 
                                    :description, 
                                    # reference
                                    :user,
                                    :amenities => [])
  end 

end
