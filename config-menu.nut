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
	}

	function key_detect(signal_str)
	{
		switch (signal_str)
		{
			case "down"   : this.down_action()   ; break;
			case "up"     : this.up_action()     ; break;
			case "select" : this.select_action() ; break;
			case "left"   : this.left_action()   ; break;
			case "right"  : this.right_action()  ; break;
			case "custom1": this.custom1_action() ;break;
			default:
				return false;
		}
		return true;
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
				::popup_menu.set_message("Are you sure you want to reset to Default Settings ?");
				::popup_menu.set_options(["Yes", "No"], 1);
				::popup_menu.show();
				this.draw();
				break;

			case "dipswitch":
				local dipswitch = menu_entry["dipswitch"]; 
				::popup_menu.set_message("Choose a new setting for\n" + dipswitch.name.toupper());
				::popup_menu.set_options(dipswitch.values, dipswitch.current_idx);
				::popup_menu.show();
				this.draw();
				break;

			default:
				print("Config action not yet implemented\n");
		}
	}

	function custom1_action()
	{
		local menu_entry = menu_entries[select_idx];

		switch (menu_entry["type"]) {
			case "reset":
				if (::popup_menu.last_selected_value() == "Yes") {
					this.reset_all_options();
				}
				break;

			case "dipswitch":
				menu_entry["dipswitch"].set(::popup_menu.last_selected_idx());
				draw();
				break;

			default:
				print("Config action not yet implemented\n");
		}
	}

	function reset_all_options()
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

		this.load();
		this.draw();

        local enlarge = {property = "scale", start=0.1, end=1, time = 300, 	tween = Tween.Quart}
        animation.add(PropertyAnimation(this.surface, enlarge));
	}

	function hide()
	{
		this.is_active = false;
		this.surface.visible = false;
	}
}