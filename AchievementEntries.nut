class AchievementEntries {
	PAGE_SIZE = 9;

	m_x = 0;
	m_y = 0;
	
	m_info = null;
	m_info_selected = 0;
	m_info_start = 0;
	m_info_end = 0;

	m_achivement_entries = null;

	constructor(x, y) {
		# Save the x,y coordinates for later user
		m_x = x; m_y = y;

		# Create the achivement entris 
		m_achivement_entries = [];
		for (local i=0; i<PAGE_SIZE; i++) {
			local entry = AchievementEntry(m_x, m_y+83*i);
			m_achivement_entries.push(entry)
		}
	}

	# Signal handler for navigatin the achievents list
	function key_detect(signal_str) {
		if (signal_str == "next_game") {
			# Select the next element in list
			m_info_selected++;

			# Prevent the selection to go over the end of the list
			if (m_info_selected > m_info.Achievements.len() - 1) {
				m_info_selected = m_info.Achievements.len() - 1;
			}

			# Redraw the achievements list
			draw();

			# Prevent the default action for the button
			return true;
		}

		if (signal_str == "prev_game") {
			# Select the previous element in the list
			m_info_selected--;

			# Prevent the selection to be negative
			if (m_info_selected < 0) {
				m_info_selected = 0;
			}

			# Redraw the achievements list
			draw();

			# Prevent the default action for the button
			return true;
		}

    	# Allow other signals to be handled normally
    	return false;
	}

	# Loads the achivements for the current game
	function load() {
		# Detect the rom name for the current game
		local rom = fe.game_info(Info.Name);

		try {
			# Try to load the load achievements from the list
			m_info = dofile(fe.script_dir + "/achievements/nuts/"+rom+".nut");

			# Set the indexes for the start / end and selected
			m_info_selected = 0;
			m_info_start = 0;
			m_info_end = PAGE_SIZE - 1;

			# Draw the list of achievements
			draw();

		# If the achivements list was not loaded correctly (ex: missing or bad format)
		} catch(e) {
			hide();
		}
	}

	function draw() {
		# Sort achivements by keys, they are not sorted by default
		local keys = [];
		foreach (key, value in m_info.Achievements) {
		    keys.push(key);
		}
		keys.sort();

		# Calcuate the start/end indexes for the achivement info that is visible
		if (m_info_selected < m_info_start) {
			m_info_start = m_info_selected;
			m_info_end = m_info_start + PAGE_SIZE - 1;
		}
		if (m_info_selected > m_info_end) {
			m_info_end = m_info_selected;
			m_info_start = max(0, m_info_end - PAGE_SIZE) + 1;
		}

		foreach(entry_index,entry in m_achivement_entries) {
			# Translate the entry index to achivement info index
			local info_index = entry_index + m_info_start;
			
			# Load the info from the info_index into the entry
			local info = m_info.Achievements[keys[info_index]];
			entry.load(info);

			# Mark the selected achivement
			entry.deselect()
			if (m_info_selected == info_index) {
				entry.select();
			}
		}
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
	}

	function desactivate() {
		# Remove signal handler used for list navigation
		fe.remove_signal_handler(this, "key_detect");
	}
}