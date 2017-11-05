class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit ,:index, :update , :destroy]
  before_action :correct_user , only: [:edit, :update]
  before_action :admin_user,     only: [:destroy]
  def new
   @user = User.new
 end

 def show
  @user = User.find(params[:id])
end

def create
  @user = User.new(user_params)
  if @user.save
    @user.send_activation_email
    UserMailer.account_activation(@user).deliver_now
    flash[:info] = "Please check your email to activate your account."
    redirect_to root_url
      # Handle a successful save.
    else
      render 'new'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  def index
   @users = User.paginate(page: params[:page])
 end
 def edit
  @user = User.find(params[:id])
end
def update 
  @user = User.find(params[:id])
  if @user.update_attributes(user_params)
    flash[:success] = "Profile update"
    redirect_to @user
  else
    render 'edit'
  end
end
def logged_in_user
  unless logged_in?
    store_location
    flash[:danger] = "Please login"
    redirect_to login_url
  end
end
def correct_user
  @user = User.find(params[:id])
  redirect_to root_url unless @user == current_user
end

def user_params
  params.require(:user).permit(:name, :email, :password, :password_confirmation)
end

def admin_user
  redirect_to(root_url) unless current_user.admin?
end
end
