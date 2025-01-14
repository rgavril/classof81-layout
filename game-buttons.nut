class GameButtons {
	PAGE_SIZE = 6;     # Number of game buttons visible on screen
	
	buttons = [];      # Array containing the game buttons
	is_active = true;  # Whether the list is active or not

	letter = null;

	is_config_mode = false;

	constructor() 
	{
		# Create the game buttons
		this.buttons = []
		for (local i=0; i<PAGE_SIZE; i++) {
			local button = GameButton(20, 295+130*i);
			this.buttons.push(button);
		}

		this.letter = fe.add_text("A", -100, -100, 40, 40);
		this.letter.width = 50;
		this.letter.height = 195;
		this.letter.margin = 0;
		this.letter.x = 960/2 - this.letter.width/2 + 220;
		this.letter.font = "fonts/CriqueGrotesk-Bold.ttf"
		// this.letter.set_rgb(0xFF, 0x68, 0xB5);
		this.letter.style = Style.Bold;
		this.letter.align = Align.MiddleCentre;
		this.letter.char_size = 205;
		// this.letter.outline = 10;

		# Draw the buttons
		draw();
		activate();

		# Add a callback to refresh the buttons when events take place
		fe.add_transition_callback(this, "transition_callback");

		fe.add_ticks_callback(this, "ticks_callback");
	}

	function transition_callback(ttype, var, transition_time)
	{
		if (ttype == Transition.FromOldSelection) {
			this.is_config_mode = false;
			::sound_engine.play_click_sound();
			draw();
		}
	}

	function ticks_callback(tick_time) {
		if (signal_repeater.hold_time["up"] == 0 && signal_repeater.hold_time["down"] == 0) {
			animation.add(PropertyAnimation(this.letter, {property = "alpha", end=0, time=400, tween = Tween.Linear}));
		}
	}

	function key_detect(signal_str)
	{
		if (!this.is_active) {
			return false;
		}

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

		# If Game Buttons is pointing to config gear 
		# and select is pressed activate Config Menu
		if (signal_str == "select" && this.is_config_mode) {
			::config_menu.show();
			// game_buttons.desactivate();
			return true;
		}

		if (signal_str == "select" && !this.is_config_mode) {
			this.is_active = false;
			::starup_page.show();
			return true;
		}

		# If Right is pressed, activate Achivements
		if (signal_str == "right") {
			::right_box.activate();
			this.desactivate();
			return true;
		}

		if (signal_str = "up" || signal_str == "down") {
			if (signal_repeater.hold_time["up"] > 500 || signal_repeater.hold_time["down"] > 500) {
				animation.add(PropertyAnimation(this.letter, {property = "alpha", end=200, time = 100, tween = Tween.Linear}));
			}

			return false;
		}

		return false;
	}

	function draw()
	{
		# Update the letter
		local y_min = 251;
		local y_max = 1111 - this.letter.height;
		local y_current = y_min + (y_max - y_min) * ((fe.list.index-1).tofloat() / fe.list.size)
		// local y_current = 200;
		this.letter.msg = fe.game_info(Info.Title).slice(0,1).toupper();
		animation.add(PropertyAnimation(this.letter, {property = "y",  end=y_current, time = 150, tween = Tween.Quart}));

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