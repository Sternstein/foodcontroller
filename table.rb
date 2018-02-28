module Table

def table_food(result)
    rows = []
    rows << ['id', 'name', 'amount', 'date','status_amount', 'status_date']
    result.each do |row|
      today = Date.today
      production_date = Date.parse row['date_in']
      exp_days = row['expire'].to_i
      exp_date = production_date + exp_days
      dif = exp_date - today
      diff = dif.to_i
      status_date = check_date(diff)
      status_amount = check_amount(row['amount'],row['speed'])
      rows << [row['id'],row['name'],row['amount'],row['date_in'],status_amount,status_date]		
    end
    table = Terminal::Table.new :rows => rows
		return table
end

def table_templates(result)
    rows = []
    rows << ['id', 'name', 'speed', 'expire', 'measure']
    result.each do |row|
    rows << [row['id'], row['name'],row['speed'],row['expire'],row['measure']]
    end
    table = Terminal::Table.new :rows => rows
    return table
end
  
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

end
