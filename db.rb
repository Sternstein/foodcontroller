# Works with database
class Db
  def check_date(date)
    case date
      when 0..2
        return Rainbow("WARNING").orange
      when 3..700
	return Rainbow("OK").white
      else
        return Rainbow("NOT OK").red
      end
  end

  def check_amount(amount,speed)
    sp = speed.to_i
    am = amount.to_i
    if sp >= am
      return Rainbow("NOT OK").red
    else
     return Rainbow("OK").white
    end
  end

	def bad_products
    conn = PG.connect( dbname: 'fooddb', user: ENV['USER'], password: ENV['PASS'] )
    result = conn.exec( "select food.id as id,templates.expire as expire,templates.name as name,templates.measure as measure,templates.speed as speed,food.amount as amount,food.date_in as date from food inner join templates on food.template_id=templates.id;" )
		conn.close
		return result	
	end

  def show
    conn = PG.connect( dbname: 'fooddb', user: ENV['USER'], password: ENV['PASS'] )
    result = conn.exec( "select food.id as id,templates.expire as expire,templates.name as name,templates.speed as speed,food.amount as amount,food.date_in as date from food inner join templates on food.template_id=templates.id;" )
    rows = []
    rows << ['id', 'name', 'amount', 'date', 'status_date' , 'status_amount']
    result.each do |row|
      today = Date.today
      production_date = Date.parse row['date']
      exp_days = row['expire'].to_i
      exp_date = production_date + exp_days
      dif = exp_date - today
      diff = dif.to_i
      status_date = check_date(diff)
      status_amount = check_amount(row['amount'],row['speed'])
      rows << [row['id'], row['name'],row['amount'],row['date'],status_date, status_amount ]		
    end
    table = Terminal::Table.new :rows => rows
    conn.close
    return table
  end

  def insert_template(name,sp,ex,measure)
    conn = PG.connect( dbname: 'fooddb', user: ENV['USER'], password: ENV['PASS'] )
    conn.exec( "INSERT INTO templates(name,speed,expire,measure) values ('#{name}', '#{sp}' , '#{ex}' , '#{measure}');" )
    puts "Put in table: "+ Rainbow("OK").orange
    conn.close
  end

  def show_templates_full 
    conn = PG.connect( dbname: 'fooddb', user: ENV['USER'], password: ENV['PASS'] )
    result = conn.exec( "SELECT * FROM templates;" )
    rows = []
    rows << ['id', 'name', 'speed', 'expire', 'measure']
    result.each do |row|
    rows << [row['id'], row['name'],row['speed'],row['expire'],row['measure']]
    end
    table = Terminal::Table.new :rows => rows
    puts table
    conn.close
  end

  def show_templates
    puts "List of templates : "
    conn = PG.connect( dbname: 'fooddb', user: ENV['USER'], password: ENV['PASS'] )
    res = conn.exec( "SELECT id,name FROM templates;" )
    rows = []
    rows << ['id', 'name']
    res.each do |row|
      rows << [row['id'], row['name']]
    end
    table = Terminal::Table.new :rows => rows
    puts table
    conn.close
  end

  def insert_food(arg1, arg2, arg3)
    puts arg3  
    conn = PG.connect( dbname: 'fooddb', user: ENV['USER'], password: ENV['PASS'] )
    conn.exec("INSERT INTO food(template_id,amount,date_in) VALUES (#{arg1}, #{arg2}, '#{arg3}');")
    puts "Insert in db #{arg1} , #{arg2} and #{arg3}"
    conn.close
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
    sql_init_t = "CREATE TABLE templates(id SERIAL, name varchar, description varchar, amount integer, expire integer, measure varchar, speed integer);"
    if arr.include?("templates")
      puts "Table is already exists!"
    else
      conn_f.exec(sql_init_t)
      puts "CREATE TABLE templates" 
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
