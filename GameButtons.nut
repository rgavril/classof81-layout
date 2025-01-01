class GameButtons {
	PAGE_SIZE = 6;     # Number of game buttons visible on screen
	
	buttons = [];      # Array containing the game buttons
	is_active = true;  # Whether the list is active or not

	is_config_mode = false;
	old_page_number = 0;

	constructor() 
	{
		# Create the game buttons
		this.buttons = []
		for (local i=0; i<PAGE_SIZE; i++) {
			local button = GameButton(20, 295+130*i);
			this.buttons.push(button);
		}

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
			draw();
		}
	}

	function key_detect(signal_str)
	{
		if (signal_str == "left" && !is_config_mode) {
			is_config_mode = true;
			draw();
			return true;
		}

		if (signal_str == "right" && is_config_mode) {
			this.buttons[0].set_config_mode(false);
			is_config_mode = false;
			draw();
			return true;
		}

		return false;
	}

	function draw()
	{
		# Calculate the page number
		local page_number = fe.list.index / PAGE_SIZE

		if (old_page_number != page_number) {
			foreach (button in buttons) {
				button.m_logo.alpha = 0
				button.m_logo_shadow.alpha = 0
				animation.add(PropertyAnimation(button.m_logo, {property = "alpha", end="+255", time = 500, tween = Tween.Cubic}));
				animation.add(PropertyAnimation(button.m_logo_shadow, {property = "alpha", end="+255", time = 500, tween = Tween.Cubic}));
			}
			old_page_number = page_number;
		}

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