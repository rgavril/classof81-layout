class ConfigMenu {
	PAGE_SIZE = 7;

	menu_entries = [];
	offset_idx = 0;
	select_idx = 0;

	surface = [];
	menu_buttons = [];
	is_active = false;

	constructor()
	{
		this.surface = fe.add_surface(1000, 1000);
		this.surface.set_pos(0, 245);

		# Background
		this.surface.add_image("images/config_menu.png", 0, 0);

		for (local i=0; i<PAGE_SIZE; i++) {
			//local menu_button = ConfigMenuButton(fe, 70, 310+90*i);
			local menu_button = ConfigMenuButton(this.surface, 90, 110+90*i);
			this.menu_buttons.push(menu_button);
		}

		this.load(); 
		this.draw();
		this.hide();		

		# Add a callback to refresh the list when events take place
		fe.add_transition_callback(this, "transition_callback");

		# Add a tick call back to resend key events as long as a key is pressed
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
			this.select_action();
			return true;
		}

		if (signal_str == "left") {
			this.left_action();
			return true;
		}

		if (signal_str == "right") {
			this.right_action();
			return true;
		}

		return false;
	}

	# We use this callback to move trough menu buttons when a key is hold
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

	function load() 
	{
		local rom = fe.game_info(Info.Name);

		# Clear old menu entries
		this.menu_entries = [];

		# Add 'Hide this Menu' menu entry
		this.menu_entries.push({ "type": "hide" });

		# Add dipswitch menu entries
		local dipswitches = FBNeoDipSwitches(rom);
		for (local i=0; i<dipswitches.len(); i++) {
			this.menu_entries.push({ "type": "dipswitch", "dipswitch": dipswitches.get(i) });
		}

		# Add 'Reset to Defaults' menu entry
		this.menu_entries.push({"type": "reset"})

		# Reset the offset and selected index
		this.select_idx = 0;
		this.offset_idx = 0;
	}

	function draw() 
	{
		for (local i=0; i<PAGE_SIZE; i++) {
			local menu_button = this.menu_buttons[i]
			local visible_idx = i + this.offset_idx;

			# Calculate the button vertical position
			local y = 105 + 90*i;
			if (menu_entries.len() < PAGE_SIZE) {
				local unused_space = (PAGE_SIZE - menu_entries.len()) * 90;
				local extra_padding = unused_space / (menu_entries.len()-1);
				y += extra_padding * i;
			}
			menu_button.set_y(y);

			# Mark menu item if is selected
			 if (this.select_idx == visible_idx) {
 				menu_button.select();
 			} else {
 				menu_button.deselect();
 			}

 			# Hide menu buttons that don't have a menu entry assigned
 			if (visible_idx >= menu_entries.len()) {
 				menu_button.hide();
 				continue;
 			} else {
 				menu_button.show();
 			}

 			# Change the menu button to reflect visible menu entries
 			local menu_entry = menu_entries[visible_idx];
 			switch (menu_entry["type"]) {
 				case "hide":
 					menu_button.set_label("Hide this Menu");
 					break;

 				case "reset":
 					menu_button.set_label("Reset to Default");
 					break;

 				case "dipswitch":
 					local dipswitch = menu_entry.dipswitch;
 					menu_button.set_label(dipswitch.name, dipswitch.value());
 					break;
 			}
		}

		if (this.is_active) {
			bottom_text.set("Move up or down or down to select an option for [Title]. To change that option, move left or right, or press any button. Selet \"HIDE THIS MENU\" when done.");
		}
	}

	function down_action() 
	{
		# If we're at the end of the list, no need to move forward
		if (this.select_idx + 1 == this.menu_entries.len()) {
			return;
		}

		# Select the next element in list
		this.select_idx++;

		# Scroll the list down if the selection is not visible
		if (this.select_idx > this.offset_idx + PAGE_SIZE - 1) {
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

	function right_action()
	{
		local menu_entry = menu_entries[select_idx];
		switch (menu_entry["type"]) {
			case "hide":
			case "reset":
				break;

			case "dipswitch":
				menu_entry["dipswitch"].move_to_next_value();
				break;
				
			default:
				print("Config action not yet implemented\n");
		}
		draw();
	}

	function left_action()
	{
		local menu_entry = menu_entries[select_idx];
		switch (menu_entry["type"]) {
			case "hide":
			case "reset":
				break;

			case "dipswitch":
				menu_entry["dipswitch"].move_to_prev_value();
				break;
				
			default:
				print("Config action not yet implemented\n");
		}
		draw();
	}

	function select_action()
	{
		local menu_entry = menu_entries[select_idx];
		switch (menu_entry["type"]) {
			case "hide":
				this.hide();
				break;

			case "reset":
				this.reset();
				break;

			case "dipswitch":
				local dipswitch = menu_entry["dipswitch"]; 
				popup_options.set_options(dipswitch.values, dipswitch.current_idx);
				popup_options.set_title(dipswitch.name);
				popup_options.show();
				break;

			default:
				print("Config action not yet implemented\n");
		}
	}

	function reset()
	{
		foreach (menu_entry in this.menu_entries) {
			if (menu_entry["type"] != "dipswitch") {
				continue;
			}

			local dipswitch = menu_entry["dipswitch"];
			dipswitch.reset();
		}

		this.draw();
	} 

	function show()
	{
		this.is_active = true;
		this.surface.visible = true;

        local enlarge = {property = "scale", start=0.1, end=1, time = 300, 	tween = Tween.Quart}
        animation.add(PropertyAnimation(this.surface, enlarge));
		
        draw();
	}

	function hide()
	{
		this.is_active = false;
		this.surface.visible = false;
	}
}