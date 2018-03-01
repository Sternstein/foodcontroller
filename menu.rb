module Menu

def create_template
		tp = Food.new
		name = ask "Put name of food : "
		desc = ask "Put description for food : "
		grmg = Array.new
		grmg = ["gr", "mg", "p"]
		correct_answer = nil
			until correct_answer				
				measure = (ask "Enter measure Gramms/Milligrams/Pieces : ", :limited_to => ["gr", "mg", "p"])
				correct_answer = grmg.include?(measure) ? measure : nil
				say ("Your response must be one of: gr / mg. Please try again.") unless correct_answer
				correct_answer
			end
			
		speed = ask "How fast will you eat it : "
    expire = ask "How long you can keep it : "
		sp = speed.to_i
    ex = expire.to_i
    tp.name = name
    tp.desc = desc
    tp.expiration_speed = ex
    tp.speed_of_eating = sp
    tp.measure = measure
		tp.save_template
		return tp
end

def main_menu
		puts "0. Create your own template"
		puts "1. Select from existing templates"
		choose = ask "Your choose : "
		ch = choose.to_i
		case ch
		when 0
			food = create_template
		when 1
	 	  puts table_templates(templates)	
			ans = ask "Please choose a template : "
  	  a = ans.to_i
			food = Food.new
			food = get_template(a)
		else
			raise 'Wrong data!!!'
		end
	
		amount = ask "How much do you have : "
		food.amount = amount.to_i
		puts "Choose date : "
		puts "1. Today"
		puts "2. Yesterday"
		puts "3. My date"
		an = ask 'Enter a number'
		data = an.to_i
		case data
		when 1
			date = Date.today
		when 2
			date = Date.today - 1
		when 3
			year = ask 'Enter your date in format : 2018'
			month = ask 'Enter your date in format : 01 '
			day = ask 'Enter your date in format : 31 '
			y = year.to_i
			m = month.to_i
			d = day.to_i
			date = Date.new(y,m,d)
		end
		food.date = date
		food.insert
end

end
