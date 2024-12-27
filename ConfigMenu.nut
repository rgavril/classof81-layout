class ConfigMenu {
	PAGE_SIZE = 7;

	dip_switches = [];
	first_idx = 0;
	selected_idx = 0;

	surface = [];
	menu_entrie = [];
	is_active = false;

	constructor() {
		debug();

		this.surface = fe.add_surface(1000, 1000);
		this.surface.set_pos(0, 200);

		# Background
		this.surface.add_image("images/config_menu.png", 0, 0);

		for (local i=0; i<PAGE_SIZE; i++) {
			//local menu_entry = ConfigMenuEntry(fe, 70, 310+90*i);
			local menu_entry = ConfigMenuEntry(this.surface, 70, 110+90*i);
			this.menu_entrie.push(menu_entry);
		}

		this.load(); 
		this.draw();
		this.hide();		

		# Add a callback to refresh the list when events take place
		fe.add_transition_callback(this, "transition_callback");

		# Add a tick call back to resend key events as long as a key is pressed
		fe.add_ticks_callback(this, "ticks_callback");
	}

	function transition_callback(ttype, var, transition_time) {
		debug()

		if (ttype == Transition.FromOldSelection) {
			load(); draw();
		}
	}

	function key_detect(signal_str) {
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

	down_hold_start = 0; up_hold_start = 0;
	function ticks_callback( tick_time ) {
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

	function load() {
		debug();

		local rom = fe.game_info(Info.Name);

		# Load the load dip switches for the current game
		dip_switches = FBNeoDipSwitches(rom);

		# Reset the offset and selected index
		this.selected_idx = 0;
		this.first_idx = 0;
	}

	function draw() {
		debug();

		for (local i=0; i<PAGE_SIZE; i++) {
			local menu_entry = this.menu_entrie[i]
			local visible_idx = i + this.first_idx;

			# Mark menu item if is selected
			 if (this.selected_idx == visible_idx) {
 				menu_entry.select();
 			} else {
 				menu_entry.deselect();
 			}

 			# Add the special 'hide' menu entry on position 0
			if (visible_idx == 0) {
				menu_entry.set_label("HIDE THIS MENU");
				continue;
			}

			# If there is a dipswitch to show on this position
			if (visible_idx-1 < dip_switches.len()) {
				local dip_switch = this.dip_switches.get(visible_idx-1);
				menu_entry.set_label(dip_switch.name, dip_switch.value());
				menu_entry.show();
			} else {
				menu_entry.hide();
			}
		}

		if (this.is_active) {
			bottom_text.set("Move up or down or down to select an option for [Title]. To change that option, move left or right, or press any button. Selet \"HIDE THIS MENU\" when done.");
		}
	}

	function down_action() {
		debug();

		# If we're at the end of the list, no need to move forward
		if (this.selected_idx == this.dip_switches.len()) {
			return;
		}

		# Select the next element in list
		this.selected_idx++;

		# Scroll the list down if the selection is not visible
		if (this.selected_idx > this.first_idx + PAGE_SIZE - 1) {
			this.first_idx++;
		}

		draw();
	}

	function up_action() {
		debug()

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

	function right_action() {
		if (this.selected_idx == 0) {
			return;
		}

		local dip_switch = dip_switches.get(this.selected_idx-1);
		dip_switch.move_to_next_value();

		draw();
	}

	function left_action() {
		if (this.selected_idx == 0) {
			return;
		}

		local dip_switch = dip_switches.get(this.selected_idx-1);
		dip_switch.move_to_prev_value();

		draw();
	}

	function select_action() {
		if (selected_idx == 0) {
			this.is_active = false;
			this.hide();
		} else {
			print("Config action not yet implemented\n");
		}
	}

	function show() {
		this.is_active = true;
		this.surface.visible = true;

        local enlarge = {property = "scale", start=0.1, end=1, time = 300, 	tween = Tween.Quart}
        animation.add(PropertyAnimation(this.surface, enlarge));
		
        draw();
	}

	function hide() {
		this.is_active = false;
		this.surface.visible = false;
	}
}