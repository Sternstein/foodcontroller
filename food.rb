require 'date'

class Food
	attr_reader :name	
	attr_accessor :desc
	attr_reader :amount	
	attr_reader :measure	
	attr_reader :speed_of_eating	
	attr_reader :expiration_speed	
	attr_reader :date	

	def date=(value)
		if value == ""
			raise "Date cat't be blank!"
		end
		@date = value
	end
	
	def measure=(value)	
		measures = ['gr','mg','p']
		if value == ""
			raise "Measure cat't be blank!"
		end
		if measures.include? value
			raise "Measure can be gr, mg or p!"
		end
		@measure = value
	end
	
	def name=(value)
		if value == ""
			raise "Name cat't be blank!"
		end
		@name = value
	end

	def amount=(value)
		if value < 0
			raise "Can't be negative"
		end
		@amount = value
	end

	def speed_of_eating=(value)
		if value < 0
			raise "Can't be negative"
		end
		@speed_of_eation = value
	end

	def expiration_speed=(value)
		if value < 0
			raise "Can't be negative"
		end
		@expiration_speed = value
	end

	def initialize(name="Product",desc="Empty", amount = 1, speed_of_eating = 1, expiration_speed = 1, date = Date.today, measure="p")
		self.name = name
		self.desc = desc
		self.amount = amount
		self.speed_of_eating = speed_of_eating
		self.expiration_speed = expiration_speed
		self.date = date
		self.measure = measure
	end

end
