class PlacesController < ApplicationController
    def index
    end

    def show
        places = BeermappingApi.places_in(session[:last_search])
        @place = places.select { |place| place.id == params[:id] }.last
    end

    def search
        @places = BeermappingApi.places_in(params[:city])
        session[:last_search] = params[:city].downcase
        if @places.empty?
            redirect_to places_path, notice: "No locations in #{params[:city]}"
        else 
            render :index
        end
    end
end

