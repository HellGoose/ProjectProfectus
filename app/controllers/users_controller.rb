class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :addMoney]
  helper_method :getFacebookPicURL

  def index

  end

  def show
  end

  def edit
  	if !isCurrentUser
      redirect_to user_path(params[:id])
    end
  end

  def update
  	respond_to do |format|
      if isCurrentUser && @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to '/signout', notice: 'User was deleted.' }
      format.json { head :no_content }
    end
  end

  def getFacebookPicURL
    'http://graph.facebook.com/' + @user.uid + '/picture?type=large'
  end

  def addMoney
    @user.money += Integer(params[:amount])
    @user.save
    respond_to do |format|
      msg = { :status => 'ok', :message => @user.money}
      format.json  { render :json => msg }
    end
  end

  private
  	 def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:username, :email, :image, :address, :phone, :subscriptionAmount, :amount)
    end

    def isCurrentUser
      @user.id == session[:user_id]
    end
end
