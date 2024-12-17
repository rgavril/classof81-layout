class AchievementEntries {
	m_x = 0;
	m_y = 0;
	constructor(x, y) {
		m_x = x;
		m_y = y;
		local ra = dofile(fe.script_dir + "/ra2nut/achievements.nut");

		# Sort achivements by keys
		local keys = [];
		foreach (key, value in ra.Achievements) {
		    keys.push(key);
		}
		keys.sort();

		foreach (i,key in keys) {
			AchievementEntry(m_x, m_y+85*(i++), ra.Achievements[key]);
			if (i == 8) break
		}
	}
}