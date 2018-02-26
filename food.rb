require 'date'
require 'pg'
class Food
	attr_accessor :id
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
		if !measures.include? value
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
		@speed_of_eating = value
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

	def insert
    conn = PG.connect( dbname: 'fooddb', user: ENV['USER'], password: ENV['PASS'] )
    conn.exec("INSERT INTO food(name,description,amount,expire,measure,speed,date_in) VALUES ('#{name}', '#{desc}', #{amount}, #{expiration_speed}, '#{measure}', #{speed_of_eating}, '#{date}');")
    puts "Insert in db #{name}"
    conn.close
	end
	
	def delete
    conn = PG.connect( dbname: 'fooddb', user: ENV['USER'], password: ENV['PASS'] )
    conn.exec("DELETE FROM food WHERE id=#{id};")
    puts "Deleted #{name}"
    conn.close
	end

	def update
    conn = PG.connect( dbname: 'fooddb', user: ENV['USER'], password: ENV['PASS'] )
    conn.exec("UPDATE FROM food WHERE id=#{id};")
    conn.exec("UPDATE food SET name = '#{name}', description = '#{desc}',amount = #{amount} ,expire = #{expiration_speed}, measure = '#{measure}',speed = #{speed_of_eating},date_in = '#{date}' WHERE id=#{id});")
    puts "Updated #{name}"
    conn.close
	end

end
