class OrdersController < ApplicationController
	before_filter :find_order, only: [:show, :edit, :update, :destroy]
	before_filter :authenticate_user!

	def index
		if current_user.role == "user"
			@orders = Order.where(user_id: current_user.id)
		end

		if current_user.role == "service" or current_user.role == "admin"
			@orders = Order.all
		end

		if current_user.role == "repair"
			@orders = Order.where(repair_id: current_user.id)
		end
	end

	# /items/1 GET
	def show
		unless @order
			render_404
		end
	end

	# /items/new GET
	def new
		@order = Order.new
	end

	# /items/1/edit GET
	def edit
		@user = current_user
		if @user.role == "user" and @user.id != @order.user_id
			render_403
		end
	end

	# /items POST
	def create
		@order = Order.create(order_params_for_user)
		if @order.errors.empty?
			@order.user_id = current_user.id
			@order.save
			redirect_to order_path(@order) # /items/:id
		else
			render "new"
		end
	end

	# /items/1 PUT
	def update
		if current_user.role == "user" and @order.status == "nowe"
			@order.update(order_params_for_user)
		end

		if current_user.role == "service"
			@order.update(odrer_params_for_service)
			@order.update(service_id: current_user.id)
		end

		if current_user.role == "admin"
			@order.update(odrer_params_for_admin)
			@order.update(service_id: current_user.id)
		end

		if current_user.role == "repair"
			@order.update(order_params_for_repair)
		end 

		if @order.errors.empty?
			redirect_to order_path(@order) # /items/:id
		else
			render "edit"
		end
	end

	# /items/1 DELETE
	def destroy
		if current_user.role == "admin"
			@order.destroy
			redirect_to action: "index"
		else
			render_403
		end
	end

	private

		def order_params_for_user
			params.require(:order).permit(:description, :type_of_device, :manufacturer, 
				:model, :serial_number, :term)
		end

		def odrer_params_for_service
			params.require(:order).permit(:service_id, :repair_id, :description, :status, :date_of_adoption, 
				:type_of_device, :manufacturer, :model, :serial_number)
		end

		def order_params_for_repair
			params.require(:order).permit(:status, :date_of_repair, :repair_end_date, :repair_attention, :price, :type_of_device, 
				:manufacturer, :model, :serial_number)
		end

		def odrer_params_for_admin
			params.require(:order).permit(:user_id, :service_id, :repair_id, :description, :status, :term, 
				:date_of_adoption, :date_of_repair, :repair_end_date, :repair_attention, :price, 
				:type_of_device, :manufacturer, :model, :serial_number)
		end

		def find_order
			@order = Order.where(id: params[:id]).first
			render_404 unless @order
		end
end
