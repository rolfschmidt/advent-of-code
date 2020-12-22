module main

struct Card {
pub mut:
    value int
    score int
}

fn (c Card) clone() Card {
    return Card{ value: c.value, score: c.score }
}

struct Player {
pub mut:
    cards []Card
    score int
}

fn d22_run(part2 bool) int {
	mut lines := read_day_string('day22.txt')
    blocks := lines.split('\n\n')

    mut players := []Player{ len: 2, init: Player{} }
    for card in blocks[0].all_after(':\n').split('\n').map(it.int()) {
        players[0].cards << Card{ value: card }
    }
    for card in blocks[1].all_after(':\n').split('\n').map(it.int()) {
        players[1].cards << Card{ value: card }
    }

    for mut pi1, p1 in players {
        for mut pi2, p2 in players {
            if pi1 == pi2 {
                continue
            }

            for p1.cards.len > 0 && p2.cards.len > 0 {
                println(p1.cards.map(it.value))
                println(p2.cards.map(it.value))
                if p1.cards[0].value > p2.cards[0].value {
                    p1.cards << p1.cards[0]
                    p1.cards << p2.cards[0]
                    p1.cards.delete(0)
                    p2.cards.delete(0)
                }
                else {
                    p2.cards << p2.cards[0]
                    p2.cards << p1.cards[0]
                    p1.cards.delete(0)
                    p2.cards.delete(0)
                }
            }

            break
        }
    }

    for mut player in players {
        player.cards.reverse_in_place()
        for mut i, card in player.cards {
            card.score = (i + 1) * card.value
        }
        player.cards.reverse_in_place()
    }

	return int_max(aint_sum(players[0].cards.map(it.score)), aint_sum(players[1].cards.map(it.score)))
}

fn day22a() int {
	return d22_run(false)
}

fn day22b() int {
	return 0
}
