module main

struct D7Bag {
pub mut:
	name  string
	count int = 1
	bags  []D7Bag
	shiny bool
}

fn (bags []D7Bag) make_shiny(name string) []D7Bag {
	for mut bag in bags {
		if bag.name == 'shiny gold' || bag.shiny {
			continue
		}
		for mut inner_bag in bag.bags {
			if inner_bag.name != name {
				continue
			}
			bag.shiny = true
			inner_bag.shiny = true
			bags.make_shiny(bag.name)
		}
	}
	return bags
}

fn (bags []D7Bag) count_shiny(name string) int {
	mut result := 0
	for mut bag in bags {
		if bag.name != name {
			continue
		}
		for inner_bag in bag.bags {
			result += inner_bag.count
			result += inner_bag.count * bags.count_shiny(inner_bag.name)
		}
	}
	return result
}

fn d7_parse_shiny_bags(bag_data string) []D7Bag {
	mut result := []D7Bag{}
	for mut line in bag_data.replace('\n', '').split('.') {
		if line.len < 1 {
			continue
		}
		bag_split := line.split(' bags contain ')
		mut inner_bags := []D7Bag{}
		for inner_bag in bag_split[1].split(', ') {
			if inner_bag.contains('no other') {
				break
			}
			name := inner_bag.replace(' bags', '').replace(' bag', '')[2..]
			inner_bags << D7Bag{
				name: name
				count: inner_bag[0..2].int()
			}
		}
		result << D7Bag{
			name: bag_split[0]
			bags: inner_bags
		}
	}
	return result
}

fn day07a() int {
	bag_data := read_day_string('day07.txt')
	return d7_parse_shiny_bags(bag_data).make_shiny('shiny gold').filter(it.shiny).len
}

fn day07b() int {
	bag_data := read_day_string('day07.txt')
	return d7_parse_shiny_bags(bag_data).make_shiny('shiny gold').count_shiny('shiny gold')
}
