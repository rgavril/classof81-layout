class GameButtons {
	PAGE_SIZE = 6
	
	m_buttons = null
	m_x = 0
	m_y = 0

	constructor(x, y) {
		m_x = x;
		m_y = y;

		m_buttons = []
		for (local i=0; i<PAGE_SIZE; i++) {
			local button = GameButton(m_x, m_y+125*i);
			m_buttons.push(button);
		}
	}

	function refresh() {
		# Calculate the page number
		local page_number = fe.list.index / PAGE_SIZE

		foreach(index,button in m_buttons) {
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