# Works with database
module Db

	def do_sql(sql)
    conn = PG.connect( dbname: 'fooddb', user: ENV['USER'], password: ENV['PASS'] )
    result = conn.exec(sql)
		conn.close
		return result	
	end

	def return_array(sql)
    conn = PG.connect( dbname: 'fooddb', user: ENV['USER'], password: ENV['PASS'] )
    result = conn.exec(sql)
		conn.close
		food_array = Array.new
		result.each do |f|
			food = Food.new
			food.id = f['id']
			food.name = f['name']
			food.amount = f['amount'].to_i
			food.expiration_speed = f['expire'].to_i
			food.desc = f['description']
			food.speed_of_eating = f['speed'].to_i
			food.measure = f['measure']
			food.date = f['date_in']
			food_array.push(food)
		end
		return food_array
	end

	def bad_products_date
		p = products
		bad_p = Array.new
		p.each do |f|
			diff = find_diff(f.date,f.expiration_speed)
			case diff
			when 0..10000
			else
			  bad_p.push(f)
			end
		end
		return bad_p 
	end
	
	def bad_products_amount
    sql = "select * from food where speed >= amount;"
		return_array(sql)
	end
	
  def products
		sql = "select * from food;"
		return_array(sql)
  end


  def templates 
    sql = "SELECT * FROM templates;"
		do_sql(sql)
  end

	def get_template(id)
		f = Food.new
    sql = "SELECT * FROM templates WHERE id=#{id};"
		temp = do_sql(sql)
		temp.each do |t|
    f.name = t['name']
		f.desc = t['description']
		f.measure = t['measure']
		f.expiration_speed = t['expire'].to_i
		f.speed_of_eating = t['speed'].to_i
		end 
		return f
	end

  def db_create
    check_if_exist = "SELECT datname FROM pg_database WHERE datistemplate = false;"
    conn = PG.connect( dbname: ENV['USER'], user: ENV['USER'], password: ENV['PASS'] )
    res = conn.exec(check_if_exist)
    arr = Array.new
    res.each do |r|
      arr.push(r['datname'])
    end
    if arr.include?("fooddb")
      puts "Database is already exists!"
    else
      sql_create = "CREATE DATABASE fooddb;"
      conn.exec(sql_create)
      puts "CREATE DATABASE fooddb"
    end	
    res.clear
    conn.close
    conn_f = PG.connect( dbname: 'fooddb', user: ENV['USER'], password: ENV['PASS'] )
    sql_check = "SELECT tablename FROM pg_catalog.pg_tables WHERE  schemaname != 'pg_catalog'
AND schemaname != 'information_schema';"
    sql_init = "CREATE TABLE food(id SERIAL, name varchar, description varchar, amount integer, expire integer, measure varchar, speed integer, date_in date);"
    res = conn_f.exec(sql_check)
    arr = Array.new
    res.each do |r|
      arr.push(r['tablename'])
    end
    if arr.include?("food")
      puts "Table is already exists!"
    else
      conn_f.exec(sql_init)
      puts "CREATE TABLE food" 
    end	
    sql_init_t = "CREATE TABLE templates(id SERIAL, name varchar, description varchar, expire integer, measure varchar, speed integer);"
    if arr.include?("templates")
      puts "Table is already exists!"
    else
      conn_f.exec(sql_init_t)
      puts "CREATE TABLE templates"
			put_templates 
    end	
      res.clear
      conn_f.close
  end

  def db_drop
    check_if_exist = "SELECT datname FROM pg_database WHERE datistemplate = false;"
    conn = PG.connect( dbname: ENV['USER'], user: ENV['USER'], password: ENV['PASS'] )
    res = conn.exec(check_if_exist)
    arr = Array.new
    res.each do |r|
      arr.push(r['datname'])
    end
    if arr.include?("fooddb")
      sql_drop = "DROP DATABASE fooddb;"
      conn.exec(sql_drop)
      puts "DROP DATABASE fooddb"
    else
      puts "Database doesn\'t exists"	
    end
    res.clear
    conn.close
  end
end
