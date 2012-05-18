class FavsController < ApplicationController
  # GET /favs
  # GET /favs.json
  def index
    @favs = Fav.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @favs }
    end
  end

  # GET /favs/1
  # GET /favs/1.json
  def show
    @fav = Fav.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @fav }
    end
  end

  # GET /favs/new
  # GET /favs/new.json
  def new
    @fav = Fav.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @fav }
    end
  end

  # GET /favs/1/edit
  def edit
    @fav = Fav.find(params[:id])
  end

  # POST /favs
  # POST /favs.json
  def create
    @fav = Fav.new(params[:fav])

    respond_to do |format|
      if @fav.save
        format.html { redirect_to @fav, notice: 'Fav was successfully created.' }
        format.json { render json: @fav, status: :created, location: @fav }
      else
        format.html { render action: "new" }
        format.json { render json: @fav.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /favs/1
  # PUT /favs/1.json
  def update
    @fav = Fav.find(params[:id])

    respond_to do |format|
      if @fav.update_attributes(params[:fav])
        format.html { redirect_to @fav, notice: 'Fav was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @fav.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /favs/1
  # DELETE /favs/1.json
  def destroy
    @fav = Fav.find(params[:id])
    @fav.destroy

    respond_to do |format|
      format.html { redirect_to favs_url }
      format.json { head :no_content }
    end
  end
end
