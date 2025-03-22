/*
	option.label();
	option.value();
	option.options();
	option.select_next_option();
	option.select_prev_options();
	option.select_idx(idx);
*/
class ConfigMenuOptionDipswitch {
	dipswitch = null

	constructor(dipswitch) {
		this.dipswitch = dipswitch;
	}

	function label() {
		return this.dipswitch.get_name();
	}

	function value() {
		return this.dipswitch.get_value();
	}

	function options() {
		return this.dipswitch.get_possible_values();
	}

	function select_next_option() {
		local idx = (this.current_idx() + 1) % this.options().len();
		this.select_idx(idx);
	}

	function select_prev_options() {
		local idx = (this.current_idx() + this.options().len() - 1) % this.options().len();
		this.select_idx(idx);
	}

	function select_idx(idx) {
		local value = this.dipswitch.get_possible_values()[idx];
		this.dipswitch.set_value(this.dipswitch.get_possible_values()[idx]);		
	}

	function current_idx() {
		local dipswitch_values = this.dipswitch.get_possible_values();

		local curr_value = this.dipswitch.get_value();
		local curr_idx   = dipswitch_values.find(curr_value);

		if (curr_idx == null) {
			curr_value = this.dipswitch.get_default_value();
			curr_idx   = dipswitch_values.find(curr_value);
		}

		return curr_idx;
	}

	function reset() {
		this.dipswitch.set_value(this.dipswitch.get_default_value());
	}
}

class ConfigMenuOptionVersions {
	rom = "";
	versions = [];

	constructor(rom) {

		this.rom = rom;

		versions = [];
		foreach (clone_rom in romlist.game_clones(this.rom)) {
			versions.push(clone_rom);
		}
		versions.push(rom);
	}

	function label() {
		return "Version"
	}

	function value() {
		local current_rom = diversions.get(this.rom);

		return (romlist.game_info(current_rom, Info.Title));
	}

	function options() {
		local values = [];

		foreach (version in this.versions) {
			values.push(romlist.game_info(version, Info.Title));
		}

		return values;
	}

	function select_next_option() {
		local idx = (this.current_idx() + 1) % this.options().len();
		this.select_idx(idx);
	}

	function select_prev_options() {
		local idx = (this.current_idx() + this.options().len() - 1) % this.options().len();
		this.select_idx(idx);
	}

	function select_idx(idx) {
		local clone_rom = this.versions[idx];
		diversions.set(this.rom, clone_rom);
	}

	function current_idx() {
		local current_rom = diversions.get(this.rom);

		return this.versions.find(current_rom);
	}

	function reset() {
		diversions.set(this.rom, this.rom);
	}
}

class ConfigMenu {
	PAGE_SIZE = 7;

	menu_entries = [];
	offset_idx = 0;
	select_idx = 0;

	surface = [];
	menu_buttons = [];
	warning_text = null;
	is_active = false;

	constructor()
	{
		# Drawing Surface
		this.surface = fe.add_surface(1000, 1000)
		this.surface.x       = 0
		this.surface.y       = 245
		this.surface.visible = false

		# Background
		this.surface.add_image("images/config_menu.png", 0, 0)

		# Missing Dipswitch File Warning
		this.warning_text           = this.surface.add_text("", 80, 75, 780, 30)
		this.warning_text.align     = Align.TopCentre
		this.warning_text.char_size = 24
		this.warning_text.visible   = false
		this.warning_text.alpha     = 180
		// this.warning_text.set_rgb(255, 100, 100)

		# Config Menu Buttons Array
		for (local i=0; i<PAGE_SIZE; i++) {
			local menu_button = ConfigMenuButton(this.surface, 90, 110+90*i)
			this.menu_buttons.push(menu_button)
		}
	}

	function key_detect(signal_str)
	{
		if ( ! this.is_active ) {
			return false
		}

		switch ( signal_str )
		{
			case "down"   : this.down_action()    ; break;
			case "up"     : this.up_action()      ; break;
			case "select" : this.select_action()  ; break;
			case "left"   : this.left_action()    ; break;
			case "right"  : this.right_action()   ; break;
			case "back"   : this.hide()           ; break;
			case "custom1": this.custom1_action() ; break;
			default:
				return false;
		}

		return true
	}

	function load() 
	{
		local rom = fe.game_info(Info.Name)

		# Clear old menu entries
		this.menu_entries = []

		# Add 'Hide this Menu' entry
		this.menu_entries.push({ "type": "hide" })

		# Add 'Version' entry
		if ( romlist.game_clones(rom).len() > 0) {
			this.menu_entries.push({ "type": "versions", "versions": ConfigMenuOptionVersions(rom) })
		}

		# Read 'Dipswitch' entries
		local dipswitches = fbneo.dipswitches(rom);
		if (dipswitches == null) {
			dipswitches = [];

			this.warning_text.msg     = "WARNING: Dipswitch Definition File is Missing or Invalid!";
			this.warning_text.visible = true;
		} else {
			this.warning_text.visible = false;
		}

		# Add 'Dipswitch' entries
		foreach (dipswitch in dipswitches) {
			# If dispwitch is marked as advanced, don't add it
			if ( dipswitch.is_advanced ) { continue }

			# Add the actual dipswitch menu entry
			this.menu_entries.push({ "type": "dipswitch", "dipswitch": ConfigMenuOptionDipswitch(dipswitch) })
		}

		# Add 'Reset to Defaults' menu entry
		this.menu_entries.push({ "type": "reset" })

		# Reset the offset and selected index
		this.select_idx = 0
		this.offset_idx = 0
	}

	function draw() 
	{
		# Update and Draw Menu Buttons
		foreach ( menu_button_idx,menu_button in this.menu_buttons ) {
			# Calculate the menu entry index associated with this menu button
			local menu_entry_idx = menu_button_idx + this.offset_idx

 			# Set Visibility
 			if ( menu_entry_idx >= menu_entries.len() ) {
 				menu_button.hide()
 				continue
 			} else {
 				menu_button.show()
 			}

			# Set Verical Position
			local button_y = 105 + 90*menu_button_idx
			if ( menu_entries.len() < PAGE_SIZE ) {

				local unused_space = (PAGE_SIZE - menu_entries.len())*90 - 20*2
				local extra_padding = unused_space / (menu_entries.len() - 1)
				button_y += extra_padding * menu_button_idx + 20
			}
			menu_button.set_y(button_y)

			# Set Select Status
			 if ( this.select_idx == menu_entry_idx ) {
 				menu_button.select()
 			} else {
 				menu_button.deselect()
 			}

 			# Set Text Label and Value
			local menu_entry = menu_entries[menu_entry_idx]
 			switch (menu_entry["type"]) {
 				case "hide":
 					menu_button.set_label("Hide this Menu")
 					menu_button.set_value(null)
 					break

				case "versions":
					menu_button.set_label(menu_entry["versions"].label())
					menu_button.set_value(menu_entry["versions"].value())
					break

 				case "reset":
 					menu_button.set_label("Reset to Default")
 					menu_button.set_value(null)
 					break

 				case "dipswitch":
 					menu_button.set_label(menu_entry["dipswitch"].label())
 					menu_button.set_value(menu_entry["dipswitch"].value())
 					break
 			}

 			# Redraw
 			menu_button.draw()
		}

		# Update the bottom text info
		if ( this.is_active ) {
			::bottom_text.set("Move up or down or down to select an option for [Title]. To change that option, move left or right, or press any button. Select \"HIDE THIS MENU\" when done.")
		}

		if (! fe.path_test(AM_CONFIG["fbneo_config_file"], PathTest.IsFile)) {
			this.warning_text.msg = "WARNING: Layout Option 'FB Neo Config File' is not set correctly !";
			this.warning_text.visible = true;
		}
	}

	function down_action() 
	{
		# If we're at the end of the list, no need to move forward
		if ( this.select_idx + 1 == this.menu_entries.len() ) {
			return
		}

		# Play a sound
		::sound_engine.play_click_sound()

		# Select the next element in list
		this.select_idx++

		# Scroll the list down if the selection is not visible
		if ( this.select_idx > this.offset_idx + PAGE_SIZE - 1 ) {
			this.offset_idx++
		}

		# Redraw
		this.draw()
	}

	function up_action()
	{
		# If we're at the begining of the list, no need to move back
		if ( this.select_idx == 0 ) {
			return
		}

		# Play a sound
		::sound_engine.play_click_sound()

		# Select the previous element in the list
		this.select_idx--

		# Scroll the list up if the selection is not visible
		if ( this.select_idx < this.offset_idx ) {
			this.offset_idx--
		}

		# Redraw
		this.draw()
	}

	function right_action()
	{
		local menu_entry = menu_entries[select_idx]

		switch ( menu_entry["type"] ) {
			case "hide":
				break

			case "reset":
				break

			case "dipswitch":
				::sound_engine.play_click_sound()
				menu_entry["dipswitch"].select_next_option()
				break

			case "versions":
				::sound_engine.play_click_sound()
				menu_entry["versions"].select_next_option()
				break
		}

		# Redraw
		this.draw()
	}

	function left_action()
	{
		local menu_entry = menu_entries[select_idx]

		switch ( menu_entry["type"] ) {
			case "hide":
				break

			case "reset":
				break

			case "dipswitch":
				::sound_engine.play_click_sound()
				menu_entry["dipswitch"].select_prev_options()
				break

			case "versions":
				::sound_engine.play_click_sound()
				menu_entry["versions"].select_prev_options()
				break
		}

		this.draw()
	}

	function select_action()
	{
		local menu_entry = menu_entries[select_idx]

		switch ( menu_entry["type"] ) {
			case "hide":
				this.hide()
				break

			case "versions":
				::popup_menu.set_message     ( "What version do you want to play ?" )
				::popup_menu.set_options     ( menu_entry["versions"].options() )
				::popup_menu.set_selected_idx( menu_entry["versions"].current_idx() )
				::popup_menu.show()
				break

			case "reset":
				::popup_menu.set_message     ( "Are you sure you want to reset to Default Settings ?" )
				::popup_menu.set_options     ( ["Yes", "No"] )
				::popup_menu.set_selected_idx( 1 )
				::popup_menu.show()
				break

			case "dipswitch":
				::popup_menu.set_message     ( "Choose a new setting for\n" + menu_entry["dipswitch"].label().toupper() )
				::popup_menu.set_options     ( menu_entry["dipswitch"].options() )
				::popup_menu.set_selected_idx( menu_entry["dipswitch"].current_idx() )
				::popup_menu.show()
				break
		}

		this.draw()
	}

	function custom1_action()
	{
		local menu_entry = menu_entries[select_idx]

		switch ( menu_entry["type"] ) {
			case "reset":
				local popup_value = ::popup_menu.get_selected_value()
				if ( popup_value == "Yes" ) {
					this.reset_all_options()
				}
				break

			case "versions":
				local popup_idx = ::popup_menu.get_selected_idx()
				menu_entry["versions"].select_idx( popup_idx )
				break

			case "dipswitch":
				local popup_idx = ::popup_menu.get_selected_idx()
				menu_entry["dipswitch"].select_idx( popup_idx )
				break

			case "hide":
				break
		}

		# Redraw
		this.draw()
	}

	function reset_all_options()
	{
		foreach ( menu_entry in this.menu_entries ) {
			switch ( menu_entry["type"] ) {
				case "dipswitch":
					menu_entry["dipswitch"].reset()
					break

				case "versions":
					menu_entry["versions"].reset()
					break
			}
		}

		# Redraw
		this.draw()
	} 

	function show()
	{
		# Play a sound
		::sound_engine.play_enter_sound()

		# Mark as Active and make it Visible
		this.is_active = true
		this.surface.visible = true
		this.surface.redraw = true;

		# Load and Redraw
		this.load()
		this.draw()

		# Animate 
		local animate_enlarge = { property = "scale", start = 0.1, end = 1, time = 300, tween = Tween.Quart }
		local animate_fadein  = { property = "alpha", start = 0  , end=255, time = 150, tween = Tween.Quart }
		animation.add( PropertyAnimation(this.surface, animate_fadein ) )
        animation.add( PropertyAnimation(this.surface, animate_enlarge) )
	}

	function hide()
	{
		# Play a sound
		::sound_engine.play_exit_sound()

		# Mark as inactive
		this.is_active = false

		# Animate
		local animate_fadeout = { property = "alpha", start = 255, end = 0, time = 200, tween = Tween.Quart }
		animation.add( PropertyAnimation(this.surface, animate_fadeout) )

		this.surface.redraw = false;
	}
}