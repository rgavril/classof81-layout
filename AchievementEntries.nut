class AchievementEntries {
	PAGE_SIZE = 9;       # Number of achivements visible on screen

	list = [];           # Array containing all the achivements
	selected_idx = 0;    # The index of the selected achivement
	first_idx = 0;       # The index of the first visible achivement

	entries = [];        # Array containing the achivement entries
	is_active = false;   # Whether the list is active or not

	constructor(x, y) {
		# Create the achivement entries
		this.entries = [];
		for (local i=0; i<PAGE_SIZE; i++) {
			local entry = AchievementEntry(x, y+80*i);
			this.entries.push(entry)
		}

		# Load and draw the achivements for the current game
		load(); draw();

		# Add a callback to refresh the list when events take place
		fe.add_transition_callback(this, "transition_callback");
	}


	function transition_callback(ttype, var, transition_time) {
		if (ttype == Transition.FromOldSelection) {
			load(); draw();
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

	# Loads the achivements info for the current game
	function load() {
		local rom = fe.game_info(Info.Name);

		# Load the load achievements from the list
		try {
			local temp = dofile(fe.script_dir + "/achievements/nuts/"+rom+".nut");
			this.list = temp.Achievements;
			sort();

		# If the achivements list was not loaded correctly (ex: missing or bad format)
		} catch(e) {
			this.list = []
			hide();
		}

		# Reset the offset and selected index
		this.selected_idx = 0;
		this.first_idx = 0;
	}

	# Sort the list of achivements
	function sort() {
		local sorted_list = [];
		local keys = [];

		foreach (key, value in this.list) {
	    	keys.push(key);
		}
		keys.sort();

		for (local i=0; i<keys.len(); i++) {
			sorted_list.push(this.list[keys[i]]);
		}

		this.list = sorted_list;
	}

	function draw() {
		for (local i=0; i<PAGE_SIZE; i++) {
			local entry = this.entries[i];
			local list_idx = this.first_idx + i;

			# Load the achivement info if there is one
			if (list_idx < this.list.len()) {
				local info = this.list[list_idx];
				entry.load(info);

			# Else hide it from screen
			} else {
				entry.hide();
			}

			# Mark entry as selected, but only when the sidebox is active
			if (this.is_active && this.selected_idx == list_idx) {
				entry.select()
			} else {
				entry.deselect();
			}
		}
	}

	function move_next() {
		# If we're at the end of the list, no need to move forward
		if (this.selected_idx == this.list.len() - 1) {
			return;
		}

		# Select the next element in list
		this.selected_idx++;

		# Scroll the list down if the selection is not visible
		if (this.selected_idx > this.first_idx + (PAGE_SIZE - 1)) {
			this.first_idx++;
		}

		draw();
	}

	function move_prev() {
		# If we're at the begining of the list, no need to move back
		if (this.selected_idx == 0) {
			return;
		}

		# Select the previous element in the list
		this.selected_idx--;

		# Scroll the list up if the selection is not visible
		if (this.selected_idx < this.first_idx) {
			this.first_idx--;
		}

		draw();
	}

	# Hide the achivements
	function hide() {
		foreach(entry in this.entries) {
			entry.hide();
		}
	}

	function activate() {
		# Add signal handler used for list navigation
		fe.remove_signal_handler(this, "key_detect");
		fe.add_signal_handler(this, "key_detect");

		this.is_active = true;

		draw();
	}

	function desactivate() {
		# Remove signal handler used for list navigation
		fe.remove_signal_handler(this, "key_detect");

		this.is_active = false;

		draw();
	}
}