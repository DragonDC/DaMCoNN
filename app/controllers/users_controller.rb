class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user,   only: [:edit, :update]   
  before_action :admin_user,     only: :destroy  
    
  def index
    @users = User.all
  end
    
    
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Witamy w DaMCoNN!"
      redirect_to @user
    else
      render 'new'
    end
  end
    
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "Użytkownik usunięty"
    redirect_to users_url
  end    

  def edit
    @user = User.find(params[:id])
  end
    
  def index
    @users = User.paginate(page: params[:page])
  end    
    
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profil zaktualizowany"
      redirect_to @user
    else
      render 'edit'
    end
  end
    
  def following
    @title = "Obserwowani"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Obserwujący"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end     

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
    
  # Confirms a logged-in user.
#    def logged_in_user
#      unless logged_in?
#        store_location   
#        flash[:danger] = "Please log in."
#        redirect_to login_url
#      end
#    end
    
  # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
  def admin_user
      redirect_to(root_url) unless current_user.admin?
  end 
    
    
     
    
end