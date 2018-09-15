class ShortenedLinksController < ApplicationController
    before_action :set_shortened_link, only: [:show, :edit, :update, :destroy]

    # GET /shortened_links
    def index
        @shortened_links = ShortenedLink.all
    end

    # GET /shortened_links/1
    def show
    end

    # GET /shortened_links/new
    def new
        @shortened_link = ShortenedLink.new
    end

    # GET /shortened_links/1/edit
    def edit
    end

    # POST /shortened_links
    def create
        is_created, message = ShortenedLink.validate_and_save(shortened_link_params)

        if is_created
            redirect_to shortened_links_url, notice: message
        else
            redirect_to new_shortened_link_url, notice: message
        end
    end

    # PATCH/PUT /shortened_links/1
    def update
        if shortened_link_params[:name].empty?
            redirect_to edit_shortened_link_url, notice: ERROR_MSG[:EMPTY_DATA]
        else
            if @shortened_link.update(shortened_link_params)
                redirect_to shortened_link_url, notice: SUCCESS_MSG[:NAME_UPDATED]
            else
                redirect_to edit_shortened_link_url, notice: ERROR_MSG[:ERROR]
            end
        end
    end

    # DELETE /shortened_links/1
    def destroy
        @shortened_link.destroy
        redirect_to shortened_links_url, notice: SUCCESS_MSG[:LINK_DESTROYED]
    end

    # GET /s/*
    def translate
        sl = ShortenedLink.find_by_unique_key(params[:path])

        if sl
            sl.hit_count += 1
            sl.save
            head :moved_permanently, :location => sl.original_url      
        else
            head :moved_permanently, :location => 'http://localhost:3000/shortened_links'
        end
    end

  private
    # Setting shortened link
    def set_shortened_link
      @shortened_link = ShortenedLink.find(params[:id])
    end

    # Restrict input parameters
    def shortened_link_params
      params.require(:shortened_link).permit(:id, :name, :original_url)
    end
end