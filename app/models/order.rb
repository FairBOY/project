class Order < ActiveRecord::Base
	belongs_to :user
	after_update :date
	after_update :total_price

	def date
		if status == "przyjęte" and date_of_adoption.blank?
			update_column(:date_of_adoption, Time.now)
		end

		if status == "w realizacji" and date_of_repair.blank?
			update_column(:date_of_repair, Time.now)
		end

		if status == "zrealizowane" and repair_end_date.blank?
			update_column(:repair_end_date, Time.now)
		end

		if status == "anulowane" and repair_end_date.blank?
			update_column(:repair_end_date, Time.now)
		end
	end

	def total_price
		if term == 5
			@cena = price.to_f
			@stawka = 0.2
			@razem = @cena * @stawka + @cena
			update_column(:price, @razem)
		end

		if term == 3
			@cena = price.to_f
			@stawka = 0.3
			@razem = @cena * @stawka + @cena
			update_column(:price, @razem)
		end
	end
end
