class GameButtons {
	m_buttons = null

	constructor() {
		m_buttons = []
		for (local i=0; i<6; i++) {
			local button = GameButton(13, 305+135*i);
			m_buttons.push(button);
		}
	}

	function refresh() {
		# Calculate the page number
		local page_number = fe.list.index / 6

		foreach(index,button in m_buttons) {
			# Calculate the index relative to current selected game
			local relative_index = page_number * 6 + (index - fe.list.index)

			# Caclulate the index relative to the entire gamelist
			local absolute_index = page_number * 6 + index

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