class GameButtons {
	PAGE_SIZE = 6;   # Number of game buttons visible on screen
	_buttons = [];
	_sound_engine = null;

	constructor(x, y) {
		# Create the game buttons
		_buttons = []
		for (local i=0; i<PAGE_SIZE; i++) {
			local button = GameButton(x, y+125*i);
			_buttons.push(button);
		}

		# Activate sound engine
		_sound_engine = SoundEngine();

		# Draw the buttons
		draw();

		# Add a callback to refresh the buttons when events take place
		fe.add_transition_callback(this, "transition_callback");
	}

	function transition_callback(ttype, var, transition_time) {
		# When the selected game changes
		if (ttype == Transition.FromOldSelection) {
			_sound_engine.click()
			
			# Load and draw the achivements for the current game
			draw();
		}
	}

	function draw() {
		# Calculate the page number
		local page_number = fe.list.index / PAGE_SIZE

		foreach(index,button in _buttons) {
			# Calculate the index relative to current selected game
			local relative_index = page_number * PAGE_SIZE + (index - fe.list.index)

			# Caclulate the index relative to the entire gamelist
			local absolute_index = page_number * PAGE_SIZE + index

			# Load the logo
			button.setLogo(fe.get_art("wheel", relative_index))
			button.deselect()
			button.show()

			# If the button is pointing to a game ouside the list of games, hide it
			if (absolute_index >= fe.list.size) {
				button.hide();
			}

			# Select the current button
			if (relative_index == 0){
				button.select();
			}
		}
	}
}