class SoundEngine {
	# A click can play before the previous one had time to finish so
	# we need to be able to play multiple clicks at the same time.
	m_click_sounds = [];
	m_click_channel = 0;

	m_enter_sound = null;
	m_exit_sound = null;
	
	constructor()
	{
		# Initialize the click sounds
		for (local channel=0; channel<40; channel++) {
			m_click_sounds.push(fe.add_sound(fix_path("sounds/click.mp3"), false))
		}

		# Intializa the enter sound
		m_enter_sound = fe.add_sound(fix_path("sounds/enter.mp3"), false);

		# Intializa the enter sound
		m_exit_sound = fe.add_sound(fix_path("sounds/exit.mp3"), false);
	}

	# Play a click sound
	function play_click_sound()
	{
		m_click_sounds[m_click_channel].playing = true;
		
		# Rotate to the next channel
		m_click_channel++;
		if (m_click_channel >= m_click_sounds.len() ) {
			m_click_channel = 0;
		}
	}

	function play_enter_sound()
	{
		m_enter_sound.playing = true;
	}

	function play_exit_sound()
	{
		m_exit_sound.playing = true;
	}
}