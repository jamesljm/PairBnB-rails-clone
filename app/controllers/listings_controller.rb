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
      flash[:error] = "Admin cannot create listing." # isit?
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

  # === Search result page
  def search
    @listing_search = Listing.new
    @listing_search[:amenities] = ["gym", "pool", "sauna", "bakery"]
    # @search_param.present? ? @search_param = params[:search] : params[:search]
    # @listings = Listing.paginate(:page => params[:page], :per_page => 9)
    # === Search
    if params[:search].present?
      @listings = Listing.where(nil)
      listing_search(params).each do |key, value|
        @listings = @listings.public_send(key, value) if value.present?
      end
    else
    # === Filter
      @listings = Listing.where(nil)
      @params = params[:listing]
      # works
      listing_filter(@params).each do |key, value|
        @listings = @listings.public_send(key, value) if value.present?
      end
      @listings = @listings.price(params[:listing][:min_price], params[:listing][:max_price])
      @listings = @listings.by_place_type(params[:listing][:place_type])

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
  # === Getter
  def get_listing_with_id
    @listing = Listing.find(params[:id])
  end

  def get_owner_listing
    return User.find(Listing.find(params[:id]).user_id).listings.find(params[:id])
  end

  # A list of the param names that can be used for filtering the Listing list
  def listing_search(params)
    params.slice(:search)
  end

  def listing_filter(params)
    params[:place_type] == 'all' ? params[:place_type] = ["heaven", "earth", "hell"] : params[:place_type] = Array(params[:place_type])
    params[:amenities].reject! { |x| x == '0' }
    params.slice(:amenities, :property_type)
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
