class SoundEngine {
	# A click can play before the previous one had time to finish so
	# we need to be able to play multiple clicks at the same time.
	m_click_sounds = [];
	m_click_channel = 0;
	
	constructor()
	{
		# Initialize the click sounds
		for (local channel=0; channel<10; channel++) {
			m_click_sounds.push(fe.add_sound("sounds/click.mp3", false))
		}
	}

	# Play a click sound
	function click()
	{
		m_click_sounds[m_click_channel].playing = true;
		
		# Rotate to the next channel
		m_click_channel++;
		if (m_click_channel >= m_click_sounds.len() ) {
			m_click_channel = 0;
		}
	}
}