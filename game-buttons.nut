class GameButtons {
	PAGE_SIZE = 6;     # Number of game buttons visible on screen
	
	buttons = [];      # Array containing the game buttons
	is_active = true;  # Whether the list is active or not
	select_idx = 0;

	letter = null;

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
		this.letter.height = 250;
		this.letter.margin = 0;
		this.letter.x = 960/2 - this.letter.width/2 + 220;
		this.letter.font = "fonts/CriqueGrotesk-Bold.ttf"
		// this.letter.set_rgb(0xFF, 0x68, 0xB5);
		this.letter.style = Style.Bold;
		this.letter.align = Align.MiddleCentre;
		this.letter.char_size = 250;
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
		if (ttype == Transition.FromOldSelection && !::startup_page.is_active) {
			::sound_engine.play_click_sound();
			this.draw();
		}

		if (ttype == Transition.FromGame) {
			this.draw();
		}

		if (ttype == Transition.ToNewList) {
			this.draw();
		}
	}

	letter_alpha = 0;
	function ticks_callback(tick_time) {
		if (fe.get_input_state("up") || fe.get_input_state("down")) {
			letter_alpha+=1;
		} else {
			letter_alpha-=1;
		}

		if (letter_alpha < 0) { letter_alpha = 0; }
		if (letter_alpha > 255) { letter_alpha = 255; }

		if (letter_alpha > 0) {
			this.letter.alpha = letter_alpha;
		} else {
			this.letter.alpha = 0;
		}
	}

	function key_detect(signal_str)
	{
		if (!this.is_active) {
			return false;
		}

		# Send all signals to active button 
		if (buttons[this.select_idx].key_detect(signal_str)) {
			return true;
		}

		# If Right is pressed, activate Achivements
		if (signal_str == "right") {
			::right_box.activate();
			this.desactivate();
			return true;
		}

		return false;
	}

	function draw()
	{
		# Update the letter
		local y_min = 251;
		local y_max = 1111 - this.letter.height;
		local y_current = y_min + (y_max - y_min) * ((fe.list.index-1).tofloat() / fe.list.size)
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
			button.deselect();
			button.show();

			# If the button is pointing to a game ouside the list of games, hide it
			if (absolute_index >= fe.list.size) {
				button.hide();
			}

			# Select the current button
			if (relative_index == 0){
				this.select_idx = index;
				button.select();

				if (this.is_active) {
					button.activate();
				} else {
					button.desactivate();
				}
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