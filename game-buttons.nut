class GameButtons {
	PAGE_SIZE = 6;     # Number of game buttons visible on screen
	
	buttons = [];      # Array containing the game buttons
	is_active = true;  # Whether the list is active or not

	letter = null;
	rectangle = null;

	is_config_mode = false;

	constructor() 
	{
		# Create the game buttons
		this.buttons = []
		for (local i=0; i<PAGE_SIZE; i++) {
			local button = GameButton(20, 295+130*i);
			this.buttons.push(button);
		}

		// this.rectangle = fe.add_rectangle(0,0, 30, 30);
		this.letter = fe.add_text("A", 0, 0, 40, 40);

		# Draw the buttons
		draw();
		activate();

		# Add a callback to refresh the buttons when events take place
		fe.add_transition_callback(this, "transition_callback");
	}

	function transition_callback(ttype, var, transition_time)
	{
		if (ttype == Transition.FromOldSelection) {
			this.is_config_mode = false;
			::sound_engine.play_click_sound();
			draw();
		}
	}

	function key_detect(signal_str)
	{
		if (signal_str == "left" && !is_config_mode) {
			is_config_mode = true;
			::sound_engine.play_click_sound();
			draw();
			return true;
		}

		if (signal_str == "right" && is_config_mode) {
			this.buttons[0].set_config_mode(false);
			is_config_mode = false;
			::sound_engine.play_click_sound();
			draw();
			return true;
		}

		return false;
	}

	function draw()
	{
		# Update the letter
		this.letter.msg = fe.game_info(Info.Title).slice(0,1).toupper();
		// this.letter.msg = fe.list.index;
		local y_min = 220;
		local y_max = 1070;
		local y_current = y_min + (y_max - y_min) * (fe.list.index.tofloat() / fe.list.size)
		this.letter.y = y_current;
		this.letter.x = 456;
		this.letter.style = Style.Bold;
		
		// local x_min = 0;
		// local x_max = 960;
		// local x_current = x_min + (x_max - x_min) * (fe.list.index.tofloat() / fe.list.size)
		// this.letter.x = x_current;
		// this.letter.y = 150;

		this.letter.char_size = 23;
		this.letter.width = 25;
		this.letter.align = Align.MiddleCentre;
		this.letter.margin = 0;
		// this.rectangle.x = this.letter.x;
		// this.rectangle.y = this.letter.y;
		// this.rectangle.width = this.letter.width;
		// this.rectangle.height = this.letter.height;
		// this.rectangle.set_rgb(0,0,0);

		// this.rectangle.visible = false;
		// this.rectangle.x = this.letter.x;
		// this.rectangle.y = y_min;
		// this.rectangle.width = this.letter.width;
		// this.rectangle.height = y_max-y_min + this.letter.height/2;
		// this.rectangle.set_rgb(255,104,181);
		// this.rectangle.alpha = 200;


		# Calculate the page number
		local page_number = fe.list.index / PAGE_SIZE

		foreach(index,button in this.buttons) {
			# Calculate the index relative to current selected game
			local relative_index = page_number * PAGE_SIZE + (index - fe.list.index)

			# Caclulate the index relative to the entire gamelist
			local absolute_index = page_number * PAGE_SIZE + index

			# Load the logo
			button.setLogo(fe.get_art("wheel", relative_index))
			button.deselect()
			button.show()

			# Set the button mode
			button.set_config_mode(this.is_config_mode);

			# If the button is pointing to a game ouside the list of games, hide it
			if (absolute_index >= fe.list.size) {
				button.hide();
			}

			# Select the current button
			if (relative_index == 0){
				button.select();

				if (this.is_active) {
					button.activate();
				} else {
					button.desactivate();
				}
			}
		}

		if (this.is_active) {
			if (this.is_config_mode) {
				bottom_text.set("Press any button access settings for [Title]. Move right to select [Title] or a different game.");
			} else {
				bottom_text.set("Press any button to start [Title]. Move up or down to select a different game. Move left to change game settings for [Title]. Move righ to access Retro Achievements.");
			}
		}
	}

	function activate()
	{
		this.is_active = true;		
		draw();
	}

	function desactivate()
	{
		this.is_active = false;
		draw();
	}
}