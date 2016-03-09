class PagesController < ApplicationController
	def index
	end

	def about
	end

	def faqs
	end

	def contact
	end

	def profile
		@user = User.find(current_user)
	end

	def panel
		@user_role = current_user.role
		if @user_role == "user"
			render_403
		end
	end
end
