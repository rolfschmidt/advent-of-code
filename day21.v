module main

fn find_alli(alling map[string]map[string]int) (string, string) {
	for a, av in alling {
		avv := av.keys().map(av[it])
		max_avv := aint_max(avv)
		max_val := av.keys().filter(av[it] == max_avv)
		if avv.filter(it == max_avv).len == 1 {
			return a, max_val.first()
		}
	}
	return '', ''
}

fn remove_alli(mut alling map[string]map[string]int, ra string, ri string) {
	alling.delete(ra)
	for a, av in alling {
		for ing in av.keys() {
			if ing != ri {
				continue
			}
			alling[a].delete(ing)
		}
	}
}

fn d21_run(part2 bool) string {
	mut lines := read_day('day21.txt')
	mut ingredients := [][][]string{}
	for line in lines {
		ingredients <<
			[line.all_before(' (').split(' '), line.all_after('(contains ').all_before(')').split(', ')]
	}
	mut alling := map[string]map[string]int{}
	for data in ingredients {
		ings := data[0]
		alls := data[1]
		for a in alls {
			if a.str() !in alling.keys() {
				alling[a] = map[string]int{}
			}
			for i in ings {
				alling[a][i]++
			}
		}
	}
	mut found_alling := map[string]string{}
	mut found_ings := []string{}
	for {
		a, i := find_alli(alling)
		if a == '' {
			break
		}
		found_ings << i
		found_alling[a] = i
		remove_alli(mut alling, a, i)
	}
	if part2 {
		mut res := found_alling.keys()
		res.sort()
		return res.map(found_alling[it]).join(',')
	}
	return astring_flatten(ingredients.map(it[0])).filter(it !in found_ings).len.str()
}

fn day21a() string {
	return d21_run(false)
}

fn day21b() string {
	return d21_run(true)
}
