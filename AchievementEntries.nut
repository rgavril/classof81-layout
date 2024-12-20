class AchievementEntries {
	PAGE_SIZE = 9;

	m_x = 0;
	m_y = 0;
	
	m_info = null;
	m_info_selected = 0;
	m_info_start = 0;

	m_achivement_entries = null;

	m_is_active = false;

	constructor(x, y) {
		# Save the x,y coordinates for later user
		m_x = x; m_y = y;

		# Create the achivement entris 
		m_achivement_entries = [];
		for (local i=0; i<PAGE_SIZE; i++) {
			local entry = AchievementEntry(m_x, m_y+80*i);
			m_achivement_entries.push(entry)
		}
	}

	# Signal handler for navigatin the achievents list
	function key_detect(signal_str) {
		if (signal_str == "next_game") {
			move_next();
			return true;
		}

		if (signal_str == "prev_game") {
			move_prev();
			return true;
		}

    	# Allow other signals to be handled normally
    	return false;
	}

	# Loads the achivements for the current game
	function load() {
		# Detect the rom name for the current game
		local rom = fe.game_info(Info.Name);

		# Load the load achievements from the list
		try {
			m_info = dofile(fe.script_dir + "/achievements/nuts/"+rom+".nut");
			sort();

		# If the achivements list was not loaded correctly (ex: missing or bad format)
		} catch(e) {
			 m_info = { Achievements = [] }
			hide();
		}

		# Set the indexes for the start / end and selected
		m_info_selected = 0;
		m_info_start = 0;

		# Draw the list of achievements
		draw();
	}

	# Sort the list of achivements
	function sort() {
		local sortedAchievements = [];
		local keys = [];

		foreach (key, value in m_info.Achievements) {
	    	keys.push(key);
		}
		
		keys.sort();

		for (local i=0; i<keys.len(); i++) {
			sortedAchievements.push(m_info.Achievements[keys[i]]);
		}

		m_info.Achievements = sortedAchievements;
	}

	function draw() {
		for (local i=0; i<PAGE_SIZE; i++) {
			local entry = m_achivement_entries[i];

			# Load the achivement info if there is one
			if (m_info_start + i < m_info.Achievements.len()) {
				local info = m_info.Achievements[m_info_start + i];
				entry.load(info);

			# Else hide it from screen
			} else {
				entry.hide();
			}

			# Mark entry as selected, but only when the sidebox is active
			if (m_is_active && m_info_selected == m_info_start + i) {
				entry.select()
			} else {
				entry.deselect();
			}
		}
	}

	function move_next() {
		# If we're at the end of the list, no need to move forward
		if (m_info_selected == m_info.Achievements.len() - 1) {
			return;
		}

		# Select the next element in list
		m_info_selected++;

		# Scroll the list down if the selection is not visible
		if (m_info_selected > m_info_start+PAGE_SIZE - 1) {
			m_info_start++;
		}

		draw();
	}

	function move_prev() {
		# If we're at the begining of the list, no need to move back
		if (m_info_selected == 0) {
			return;
		}

		# Select the previous element in the list
		m_info_selected--;

		# Scroll the list up if the selection is not visible
		if (m_info_selected < m_info_start) {
			m_info_start--;
		}

		draw();
	}

	# Hide the achivements
	function hide() {
		foreach(entry in m_achivement_entries) {
			entry.hide();
		}
	}

	function activate() {
		# Add signal handler used for list navigation
		fe.remove_signal_handler(this, "key_detect");
		fe.add_signal_handler(this, "key_detect");

		m_is_active = true;

		draw();
	}

	function desactivate() {
		# Remove signal handler used for list navigation
		fe.remove_signal_handler(this, "key_detect");

		m_is_active = false;

		draw();
	}
}