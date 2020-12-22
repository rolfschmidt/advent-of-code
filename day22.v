module main

fn d22_game(pp1 []int, pp2 []int, part2 bool) ([]int, []int) {
	mut p1 := pp1.clone()
	mut p2 := pp2.clone()
	mut seen := map[string]bool{}
	for p1.len > 0 && p2.len > 0 {
		mut p1_wins := true
		if seen['$p1;$p2'] && part2 {
			break
		}
		seen['$p1;$p2'] = true
		p1c := p1[0]
		p2c := p2[0]
		p1.delete(0)
		p2.delete(0)
		if p1c <= p1.len && p2c <= p2.len && part2 {
			pm1, _ := d22_game(p1[0..p1c], p2[0..p2c], part2)
			if pm1.len > 0 {
				p1_wins = true
			} else {
				p1_wins = false
			}
		} else {
			if p1c > p2c {
				p1_wins = true
			} else {
				p1_wins = false
			}
		}
		if p1_wins {
			p1 << p1c
			p1 << p2c
		} else {
			p2 << p2c
			p2 << p1c
		}
	}
	return p1, p2
}

fn d22_run(part2 bool) int {
	mut lines := read_day_string('day22.txt')
	blocks := lines.split('\n\n')
	mut players := [][]int{}
	players << blocks[0].all_after(':\n').split('\n').map(it.int())
	players << blocks[1].all_after(':\n').split('\n').map(it.int())
	pm1, pm2 := d22_game(players[0], players[1], part2)
	players[0] = pm1
	players[1] = pm2
	for pi, player in players {
		players[pi].reverse_in_place()
		for i, card in player {
			players[pi][i] = (i + 1) * card
		}
		players[pi].reverse_in_place()
	}
	return int_max(aint_sum(players[0]), aint_sum(players[1]))
}

fn day22a() int {
	return d22_run(false)
}

fn day22b() int {
	return d22_run(true)
}
