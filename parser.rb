require 'yaml'

module Parser

def parse_yaml(file)
	YAML::load(File.open(file))
end

def put_templates
  @items = parse_yaml('templates.yml')
  @items.each do |hash|
		f = Food.new
		f.name = hash["name"]
		f.desc = hash["description"]
		f.expiration_speed = hash["expire"]
		f.speed_of_eating = hash["speed"]
		f.measure = hash["measure"]
		f.save_template
		end
end

end
