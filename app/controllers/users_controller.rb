class UsersController < ApplicationController
  include SessionsHelper
  #before_action :set_user, only: [:show,:edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    if logged_in_as_admin?
      @users = User.all.order(:is_admin)
      @count =@users.count
    else
      #Invalid or no cookie recieved in request, flash error
      redirect_to_home
    end
  end
  # GET /users/1
  # GET /users/1.json
  def show
    if !logged_in?
      #Invalid or no cookie recieved in request, flash error
      flash.now[:danger] = 'Please login to continue'
      render 'sessions/new'
      end
    else if logged_in_as_admin? || @current_user.id == params[:id]
      if params[:id]!= nil
        @user = User.find(params[:id])
      end
  end
end
  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    if params[:id]!= nil
      @user = User.find(params[:id])
    end
  end

  # POST /users
  # POST /users.json
  def create

    @user = User.new(user_params)
    if(!@user.is_admin)
      @user.is_admin = false
    end
    @user.is_root = false
    if(User.all.count == 0)
          @user.is_admin = true
          @user.is_root = true
    end
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def search_user
    if !logged_in_as_admin?
      #Invalid or no cookie recieved in request, flash error

      redirect_to_home
    end
    if params[:search_by] == "email"
      #TODO put checks here that field should not be empty
      #TODO page results here, make it case insensitive
      @users = User.where("email like ? ", "%#{params[:q]}%")
      @query = params[:q]
    elsif params[:search_by] == "name"
      @users = User.where("name like ? ", "%#{params[:q]}%") # changing ==to = for postgres
      @query = params[:q]
    else
      flash.now[:danger] = "Search failed, remember to select a criteria."
      render 'users'
    end

  end
  private
    Use callbacks to share common setup or constraints between actions.
  def set_user
     @user = User.find(params[:id])
  end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :password, :name, :is_admin, :is_root)
    end
end
