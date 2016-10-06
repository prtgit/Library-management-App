class BookingsController < ApplicationController
  include SessionsHelper
  before_action :set_booking, only: [:show, :edit, :update, :destroy]

  # GET /bookings
  # GET /bookings.json
  def index
    if logged_in_as_admin?
    @bookings = Booking.where("cancelled =?",'f')
    else
      @bookings = Booking.where("user_id =?",session[:user_id])
      end
  end

  # GET /bookings/1
  # GET /bookings/1.json
  def show
  end

  # GET /bookings/new
  def new
    @booking = Booking.new
  end

  # GET /bookings/1/edit
  def edit
  end

  # POST /bookings
  # POST /bookings.json
  def create
    @booking = Booking.new(booking_params)
    @booking.booked_by = User.find(session[:user_id]).name
    if(!@booking.user_id)
    @booking.user_id = session[:user_id]
    end
    #@allbookings = Booking.where("room_id= ?","#{booking_params[:room_id]}")
    if(@booking.booking> Time.now + 7.days || @booking.booking < Time.now)
     respond_to do |format|
      format.html { redirect_to new_booking_path ,notice: "Check your dates. Bookings cannot be made for the past or beyond 7 days from now!!"}
      format.json { render json: @booking.errors, status: :unprocessable_entity }
     end
      return
    end
    @allbookings = Booking.where("cancelled =? AND room_id= ?",'f',"#{booking_params[:room_id]}")
    @allbookings.each do |book|

          if (@booking.booking>=(book.booking) && @booking.booking<=(book.booking+2.hours))
            respond_to do |format|
            format.html { redirect_to new_booking_path ,notice: "Room booked at this time. Choose another room/time."}
            format.json { render json: @booking.errors, status: :unprocessable_entity }
            end
            return
          end
    end
    @allBookingsUser = Booking.where("cancelled =? AND user_id= ?",'f',"#{booking_params[:user_id]}")
    @allBookingsUser.each do |book|
      if (!logged_in_as_admin? && book.booking>=Time.now - 2.hours)
        respond_to do |format|
          format.html { redirect_to new_booking_path ,notice: "Please get in touch with admin to reserve another room.You have a current booking!!"}
          format.json { render json: @booking.errors, status: :unprocessable_entity }
        end
        return
      end
    end
    respond_to do |format|
      if @booking.save
        format.html { redirect_to @booking, notice: 'Booking was successfully created.' }
        format.json { render :show, status: :created, location: @booking }
      else
        format.html { render :'bookings/new' ,notice: 'Room booked at this time. Choose another room.'}
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bookings/1
  # PATCH/PUT /bookings/1.json
  def update
   # booking_params[:booked_by] = session[:user_id]
   if logged_in?
    if booking_params[:cancelled] == '1' && @booking.cancelled == false
      booking_params[:cancelled_by] = User.find(session[:user_id]).name
    end
    @allbookings = Booking.where("cancelled =? AND room_id= ?",'f',"#{booking_params[:room_id]}")
    @allbookings.each do |book|

      if (@booking.booking>=(book.booking) && @booking.booking<=(book.booking+3.hours)&& booking_params[:cancelled]=='0')
        respond_to do |format|
          format.html { redirect_to @booking ,notice: "Room booked at this time. Choose another room/time."}
          format.json { render json: @booking.errors, status: :unprocessable_entity }
        end
        return
      end
    end

    respond_to do |format|
      if @booking.update(booking_params)
        format.html { redirect_to @booking, notice: 'Booking was successfully updated.' }
        format.json { render :show, status: :ok, location: @booking }
      else
        format.html { render :edit }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
     else redirect_to_home
  end
end
  # DELETE /bookings/1
  # DELETE /bookings/1.json
  def destroy
    @booking.destroy
    respond_to do |format|
      format.html { redirect_to bookings_url, notice: 'Booking was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_booking
      @booking = Booking.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def booking_params
      params.require(:booking).permit(:id,:user_id, :room_id ,:booking, :cancelled_by, :cancelled, :booked_by)
    end
end
