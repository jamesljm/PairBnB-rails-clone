class UsersController < Clearance::BaseController
  # accessible pages with login
  before_action :require_login, only: [:edit, :update]
  # before_action :user_params, only: [:new, :create, :update]

  def new
    flash[:success] = "Welcome to the PairBnB!"
    @user = User.new
    render template: "users/new"
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
  	  sign_in @user
  		redirect_to edit_user_path(@user.id)
  	else
  		render :new
  	end
  end

  def edit
    @user = current_user
    if params[:id].to_i != current_user.id
        flash[:error] = "Not enough token"
      else
        @user = current_user
    end
  end

  def update

    if current_user.superadmin?
      # todo
    else
      @user = User.find(params[:id])
      if @user.update(user_params)
        redirect_to @user
      else
        render :edit
      end
    end

  end

  def show
    @user = User.find(params[:id])
  end

  def destroy
  end

  # only accessible by superadmin
  # def index
  # 	@user = User.all
  # end
  
  def name
    "#{self[:first_name]} #{self[:last_name]}"
  end

private
  def user_params
  	params.require(:user).permit(:first_name, :last_name, :email, :phone, :gender, :password, :birthdate, :avatar)
  end
    
end