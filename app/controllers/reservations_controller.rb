class ReservationsController < ApplicationController
  before_action :get_listing_with_id, :get_reservation_with_id, only: [:show]
  
  # for superadmin to display all the reservatios by clients
  def index
    if current_user.superadmin?
      @reservations = Reservation.all
    end
  end

  def new
    get_listing_with_id
    @reservation = Reservation.new
  end

  def create
    @listing = Listing.find(params[:listing_id])
    calculate_total(params[:reservation], Listing.find(params[:listing_id]).price)
    @reservation = current_user.reservations.new(reservation_params)
    @reservation.listing_id = @listing.id
        
    if @reservation.save
      flash[:success] = "Reservation successfully created"
      redirect_to listing_reservation_path(@listing, @reservation)
    else
      flash[:error] = "Something went wrong"
      redirect_back(fallback_location: new_listing_reservation_path)      
    end
  end
  
  def show
    get_reservation_with_id
  end
  

  def edit
  end

  def confirm
  end

private
  # Getter
  def get_reservation_with_id
    @reservation = Reservation.find(params[:id])
  end

  def get_listing_with_id
    @listing = Listing.find(params[:listing_id])
  end

  def calculate_total(reservation, price)
    reservation[:total_price] = (reservation[:end_date].to_date - reservation[:start_date].to_date).to_i * price
  end

  # strong parameters
  def reservation_params
  	params.require(:reservation).permit(:start_date, :end_date, :total_price)
  end
  
end
