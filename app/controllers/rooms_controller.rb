class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :schedule_room,:edit, :update, :destroy]

  # GET /rooms
  # GET /rooms.json
  def index
    @rooms = Room.all
  end

  # GET /rooms/1
  # GET /rooms/1.json
  def show
  end

  # GET /rooms/new
  def new
    @room = Room.new
  end

  #GET /rooms/1/schedule_room
  def schedule_room
    @bookingsWeek = Booking.where("cancelled =? AND room_id= ? AND booking > ? AND booking < ?",'f',"#{@room.id}",Time.now.beginning_of_day,Time.now.end_of_day ).order(:booking)
  end
  # GET /rooms/1/edit
  def edit
  end
  # POST /rooms
  # POST /rooms.json
  def create
    @room = Room.new(room_params)

    respond_to do |format|
      if @room.save
        format.html { redirect_to @room, notice: 'Room was successfully created.' }
        format.json { render :show, status: :created, location: @room }
      else
        format.html { render :new }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rooms/1
  # PATCH/PUT /rooms/1.json
  def update
    respond_to do |format|
      if @room.update(room_params)
        format.html { redirect_to @room, notice: 'Room was successfully updated.' }
        format.json { render :show, status: :ok, location: @room }
      else
        format.html { render :edit }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rooms/1
  # DELETE /rooms/1.json
  def destroy
    @bookingsForRoom = Booking.where("room_id == ?","%#{@room.id}%");
    @bookingsForRoom.each do|bookie|
      bookie.destroy
    end
    @room.destroy
    respond_to do |format|
      format.html { redirect_to rooms_url, notice: 'Room was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def search_room
    if params[:search_by] == "Building"
      #TODO put checks here that field should not be empty
      #TODO page results here, make it case insensitive
      @rooms = Room.where("building like ? ", "%#{params[:q]}%")
      @query = params[:q]
    elsif params[:search_by] == "size"
      @rooms = Room.where("size like ? ", "%#{params[:q]}%") # changing ==to = for postgres
      @query = params[:q]
    elsif params[:search_by] == "Number"
      @rooms = Room.where("number =? ", "#{params[:q]}") # changing ==to = for postgres
      @query = params[:q]
    else
      flash.now[:danger] = "Search failed, remember to select a criteria."
      render 'rooms/index'
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def room_params
      params.require(:room).permit(:number, :status, :building, :size)
    end
end
