# == this controller setup the search for ajax in the nav search bar
class SearchController < ApplicationController
    skip_before_action :verify_authenticity_token
    def search
        puts "these params"
        p params
        p params[:search]
        listings = Listing.search_params(params[:search])
        render json: listings
    end
end
