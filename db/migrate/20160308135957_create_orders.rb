class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
    	# Order
    	t.integer :user_id
	    t.integer :service_id
	    t.integer :repair_id
	    t.text :description
	    t.string :status, null: false, default: "nowe"
	    t.integer :term, null: false, default: "7"
	    t.datetime :date_of_adoption
	    t.datetime :date_of_repair
	    t.datetime :repair_end_date
	    t.text :repair_attention
	    t.float :price
	    # Device
	    t.string :type_of_device
	    t.string :manufacturer
	    t.string :model
	    t.string :serial_number
      t.timestamps null: false
    end
  end
end
