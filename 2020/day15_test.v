module main

fn test_day15_run() {
	assert d15_run('1,3,2', 2020) == 1
	assert d15_run('2,1,3', 2020) == 10
	assert d15_run('1,2,3', 2020) == 27
	assert d15_run('2,3,1', 2020) == 78
	assert d15_run('3,2,1', 2020) == 438
	assert d15_run('3,1,2', 2020) == 1836
}

fn test_day15a() {
	assert day15a() == 1015
}

fn test_day15b() {
	// assert day15b() == 201
}
