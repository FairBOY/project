class UsersController < ApplicationController
	before_filter :authenticate_user!

	def index
		@users = User.all
    	if current_user.role == "user"
      		render_403
    	end
	end

	def show
		@user = User.find(params[:id])
	end

	def edit
		@user = User.find(params[:id])
      	if current_user.id != @user.id and current_user.role != 'admin'
        	render_403
      	end
	end

	def update
		@user = User.find(params[:id])
      	if current_user.role == "user"
       		@user.update(params_for_user)
	        if @user.save
	          render 'show'
	      	end
        end

      	if current_user.role == "admin"
       		@user.update(params_for_admin)
	        if @user.save
	          render 'show'
	      	end
        end
	end

	def destroy
		@user = User.find(params[:id])
      	@user.destroy
      	redirect_to users_path
	end

	private

	  def params_for_user
	  	params.require(:user).permit(:email, :first_name, :last_name, :address, :phone)
	  end

	  def params_for_admin
	  	params.require(:user).permit(:email, :password, :first_name, :last_name, :address, :phone, :role)
	  end
end
