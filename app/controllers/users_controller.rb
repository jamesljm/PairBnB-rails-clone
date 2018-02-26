class UsersController < Clearance::UsersController
  # accessible pages with login
  before_action :require_login, only: [:edit, :update]

  def edit
    @user = current_user
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to @user
    else
      render :edit
    end
  end

  def show
    @user = current_user
    @reservations = current_user.reservations
  end

  def destroy
  end

  def index
  	@user = User.all
  end

private

  def user_params
  	params.require(:user).permit(:first_name, :last_name, :email, :gender, :password, :birthdate, :phone, :avatar)
  end
    
end