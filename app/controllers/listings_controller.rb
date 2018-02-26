class ListingsController < ApplicationController
  before_action :get_listing_with_id, only: [:show, :edit, :update]
  before_action :get_owner_listing, only: [:update, :destroy]
  
  # login required routes
  # before_action :require_login, only: [:new, :show, :edit, :update, :delete, :index]

  def index
    @listings = Listing.paginate(:page => params[:page], :per_page => 20)
  end
  
  def new
    if current_user.superadmin?
      flash[:error] = "Admin cannot create listing."
      redirect_to root_path
    else
      @listing = Listing.new
    end
  end

  def create
    @listing = current_user.listings.new(listing_params)
    @listing.tags.concat params["listing"]["tags"].split(",")
    
    if @listing.save
      redirect_to listing_path(@listing)
    else
      redirect_back(fallback_location: new_listing_path)
    end
  end
  
  def show
    get_listing_with_id
  end

  def edit
    if current_user.superadmin? || get_listing_with_id.user_id == current_user.id
      get_listing_with_id
    else
    # redirect if not admin or listing's user
      redirect_to root_path
      flash[:error] = "Not enough token"
    end
  end

  def update
    if params["listing"]["amenities"] == nil
      params["listing"]["amenities"] = []
    end
    # superadmin now able to edit owner's listing
    @listing = get_owner_listing
    if @listing.update(listing_params)
      redirect_to @listing
      flash[:success] = "Update complete"
    end
  end

  # able to search
  # 1. tags
  def search
    if params[:search]
      @lists = []
      Listing.all.each do |list|
        if list.tags.map(&:downcase).include? params[:search].downcase
          @lists << list
        end
      end
    end
    # if item searched if not found
    if @lists.empty?
      flash[:notice] = "Search not found!"
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    if current_user.superadmin? || Listing.find(params[:id]).user_id == current_user.id
      @listing = Listing.find(params[:id]).delete
    else
    # redirect if not admin or user
      flash[:error] = "Not enough token"
      redirect_to sign_in_path
    end
  end

private
  # Getter
  def get_listing_with_id
    @listing = Listing.find(params[:id])
  end

  def get_owner_listing
    return User.find(Listing.find(params[:id]).user_id).listings.find(params[:id])
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
                                    :amenities => [],
                                    :images => [])
  end 

end
