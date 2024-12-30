class AchievementEntries {
	PAGE_SIZE = 8;       # Number of achivements visible on screen

	achievements = [];   # Array containing all the achivements
	select_idx = 0;    # The index of the selected achivement
	offset_idx = 0;       # The index of the first visible achivement

	entries = [];        # Array containing the achivement entries
	border_image = null; # Achivements Box Boder
	missing_message = null;
	is_active = false;   # Whether the list is active or not

	constructor()
	{
		# Create the achivement entries
		this.entries = [];
		for (local i=0; i<PAGE_SIZE; i++) {
			local entry = AchievementEntry(475, 360+80*i);
			this.entries.push(entry)
		}

		# Title Shadow
		local title_shadow = fe.add_text("[!TitleFormated]", 470+1, 238+1, 460, 50);
		title_shadow.font = "CriqueGrotesk-Bold.ttf";
		title_shadow.set_rgb(0,0,0);
		title_shadow.char_size = 36;
		title_shadow.align = Align.TopCentre;

		# Title
		local title = fe.add_text("[!TitleFormated]", 470, 238, 460, 50);
		title.font = "CriqueGrotesk-Bold.ttf";
		title.set_rgb(255,104,181);
		title.char_size = 36;
		title.align = Align.TopCentre;

		# Subtitle
		local subtitle = fe.add_text("[Year] [Manufacturer]", 480, 290, 440, 42);
		subtitle.set_rgb(255,252,103);
		subtitle.char_size = 28;
		subtitle.align = Align.TopCentre;

		# Sidebox Border
		this.border_image = fe.add_image("images/sidebox_active.png", 460, 220);
		this.border_image.visible = false;

		# No Achivements Message
		this.missing_message = fe.add_text("This game has no\nRetro Achivements!", 480, 450, 440, 320);
		this.missing_message.char_size = 30;
		this.missing_message.line_spacing = 1.2;
		this.missing_message.align = Align.MiddleCentre;
		this.missing_message.word_wrap = true;
		this.missing_message.visible = false;

		# Load and draw the achivements for the current game
		load(); draw();

		# Add a callback to refresh the list when events take place
		fe.add_transition_callback(this, "transition_callback");
		fe.add_ticks_callback(this, "ticks_callback");
	}

	function transition_callback(ttype, var, transition_time)
	{
		if (ttype == Transition.FromOldSelection) {
			load(); draw();
		}
	}

	function key_detect(signal_str)
	{
		if (signal_str == "down") {
			this.down_action();
			return true;
		}

		if (signal_str == "up" ) {
			this.up_action();
			return true;
		}

		if (signal_str == "select") {
			print("Achievements action not yet implemented\n");
			return true;
		}

		return false;
	}

	down_hold_start = 0; up_hold_start = 0;
	function ticks_callback( tick_time )
	{
		# Don't register keys if we're not active
		if (! this.is_active) { return; }

		if (fe.get_input_state("down")) { 
			if (down_hold_start == 0) {
				down_hold_start = tick_time + 500;
			}

			if (tick_time - down_hold_start > 100) {
				down_hold_start = tick_time;
				this.key_detect("down");
			}
		} else {
			down_hold_start = 0;
		}

		if (fe.get_input_state("up")) { 
			if (up_hold_start == 0) {
				up_hold_start = tick_time + 500;
			}

			if (tick_time - up_hold_start > 100) {
				up_hold_start = tick_time;
				this.key_detect("up");
			}
		} else {
			up_hold_start = 0;
		}
	}

	# Loads the achivements info for the current game
	function load()
	{
		local rom = fe.game_info(Info.Name);

		# Load the load achievements from the list
		try {
			local temp = dofile(fe.script_dir + "/achievements/nuts/"+rom+".nut");
			this.achievements = temp.Achievements;
			sort();

		# If the achivements list was not loaded correctly (ex: missing or bad format)
		} catch(e) {
			this.achievements = []
			hide();
		}

		# Reset the offset and selected index
		this.select_idx = 0;
		this.offset_idx = 0;
	}

	# Sort the list of achivements
	function sort()
	{
		local sorted_list = [];
		local keys = [];

		foreach (key, value in this.achievements) {
	    	keys.push(key);
		}
		keys.sort();

		for (local i=0; i<keys.len(); i++) {
			sorted_list.push(this.achievements[keys[i]]);
		}

		this.achievements = sorted_list;
	}

	function draw()
	{
		for (local i=0; i<PAGE_SIZE; i++) {
			//continue;
			
			local entry = this.entries[i];
			local visible_idx = this.offset_idx + i;

			# Hide achivement entry if it points to a non existing achivement
			if (visible_idx >= this.achievements.len()) {
				entry.hide();
				continue;
			}

			# Set the achivement information to the entry
			local achivement = this.achievements[visible_idx];
			entry.set_achivement(achivement);

			# Mark entry as selected, but only when the achivements are active
			if (this.is_active && this.select_idx == visible_idx) {
				entry.select()
			} else {
				entry.deselect();
			}
		}

		if (this.achievements.len() == 0) {
			this.missing_message.visible = true;
		} else {
			this.missing_message.visible = false;
		}

		# Toggle background border based on activity
		this.border_image.visible = this.is_active;

		# Update the instrutions bottom text
		if (this.is_active) {
			bottom_text.set("Move up or down to browse the Achievements. Press any button to view this Achivement. Move left to play [Title] or a different game.");
		}
	}

	function down_action()
	{
		# If we're at the end of the list, no need to move forward
		if (this.select_idx == this.achievements.len() - 1) {
			return;
		}

		# Select the next element in list
		this.select_idx++;

		# Scroll the list down if the selection is not visible
		if (this.select_idx > this.offset_idx + (PAGE_SIZE - 1)) {
			this.offset_idx++;
		}

		draw();
	}

	function up_action()
	{
		# If we're at the begining of the list, no need to move back
		if (this.select_idx == 0) {
			return;
		}

		# Select the previous element in the list
		this.select_idx--;

		# Scroll the list up if the selection is not visible
		if (this.select_idx < this.offset_idx) {
			this.offset_idx--;
		}

		draw();
	}

	# Hide the achivement entries
	function hide()
	{
		foreach(entry in this.entries) {
			entry.hide();
		}
	}

	function activate()
	{
		this.is_active = true;
		draw();
	}

	function desactivate() {
		this.is_active = false;
		draw();
	}
}