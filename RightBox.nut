class RightBox
{
	is_active = false;
	border_image = null;
	connection_bar = null;

	constructor()
	{
		//475, 235, 450, 840
		# Title Shadow
		local title_shadow = fe.add_text("[!TitleFormated]", 475+1, 235+1, 450, 50)
		title_shadow.font = "CriqueGrotesk-Bold.ttf"
		title_shadow.set_rgb(0,0,0)
		title_shadow.char_size = 36
		title_shadow.align = Align.TopCentre

		# Title
		local title = fe.add_text("[!TitleFormated]", 475, 235, 450, 50)
		title.font = "CriqueGrotesk-Bold.ttf";
		title.set_rgb(255,104,181);
		title.char_size = 36;
		title.align = Align.TopCentre;

		# Subtitle
		local subtitle = fe.add_text("[Year] [Manufacturer]", 475, 235+50, 450, 50);
		subtitle.set_rgb(255,252,103);
		subtitle.char_size = 26;
		subtitle.align = Align.TopCentre;

		# Sidebox Border
		this.border_image = fe.add_image("images/sidebox_active.png", 460, 220);
		this.border_image.visible = false;

		# Connection Bar
		this.connection_bar = fe.add_image("images/connection_bar_inactive.png", 460, 340);
		this.connection_bar.origin_x = this.connection_bar.texture_width;
		this.connection_bar.origin_y = this.connection_bar.texture_height / 2;
		this.connection_bar.visible = true;
		
		# Add a callback to refresh the buttons when events take place
		fe.add_transition_callback(this, "transition_callback");

		draw();
	}

	function transition_callback(ttype, var, transition_time)
	{
		if (ttype == Transition.FromOldSelection) {
			draw();
		}
	}

	function key_detect(signal_str)
	{

	}

	function draw()
	{
		# Sidebox Border
		this.border_image.visible = this.is_active;

		# Connection Bar
		if (this.is_active) {
			this.connection_bar.file_name = "images/connection_bar_active.png";
		} else {
			this.connection_bar.file_name = "images/connection_bar_inactive.png";
		}
		// this.connection_bar.set_pos(460, 340 + (fe.list.index % 6) * 130);
		local end_y = 340 + (fe.list.index % 6) * 130
		local enlarge = { property = "y", end=end_y, time = 300, tween = Tween.Quart }
        animation.add(PropertyAnimation(this.connection_bar, enlarge));
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