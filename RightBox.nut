class RightBox
{
	is_active = false;
	border_image = null;
	connection_bar = null;

	overview_text = null;
	overview_shadow = null;

	constructor()
	{

		# Snap
		local snap = fe.add_artwork("snap", 0, 0);
		snap.width = 450;
		snap.height = snap.width * 4/3;
		snap.x = 475;
		snap.y = 235+840 - snap.height;
		// snap.shader = fe.add_shader(Shader.Fragment, "shaders/desaturate.glsl");
		fe.add_image("images/test.png", 475, 235);


		# Title Shadow
		local title_shadow = fe.add_text("[!TitleFormated]", 475+1, 235+10+1, 450, 50)
		title_shadow.font = "CriqueGrotesk-Bold.ttf"
		title_shadow.set_rgb(0,0,0)
		title_shadow.char_size = 36
		title_shadow.align = Align.TopCentre

		# Title
		local title = fe.add_text("[!TitleFormated]", 475, 235+10, 450, 50)
		title.font = "CriqueGrotesk-Bold.ttf";
		title.set_rgb(255,104,181);
		title.char_size = 36;
		title.align = Align.TopCentre;

		# Sidebox Border
		this.border_image = fe.add_image("images/sidebox_active.png", 460, 220);
		this.border_image.visible = false;

		# Connection Bar
		this.connection_bar = fe.add_image("images/connection_bar_inactive.png", 460, 340);
		this.connection_bar.origin_x = this.connection_bar.texture_width;
		this.connection_bar.origin_y = this.connection_bar.texture_height / 2;
		this.connection_bar.visible = true;

		# Overview Short
		this.overview_shadow = fe.add_text("", 475+2, 235+65+2, 450, 840-65);
		this.overview_shadow.align = Align.TopCentre;
		this.overview_shadow.char_size = 26;
		this.overview_shadow.word_wrap = true;
		this.overview_shadow.margin = 20;
		this.overview_shadow.set_rgb(0, 0, 0);

		this.overview_text = fe.add_text("", 475, 235+65, 450, 840-65);
		this.overview_text.align = Align.TopCentre;
		this.overview_text.char_size = 26;
		this.overview_text.word_wrap = true;
		this.overview_text.margin = 20;
		this.overview_text.set_rgb(255, 252, 103);

		draw();

		# Add a callback to refresh the buttons when events take place
		fe.add_transition_callback(this, "transition_callback");
		
		# Add a tick call back to resend key events as long as a key is pressed
		fe.add_ticks_callback(this, "ticks_callback");
	}

	function transition_callback(ttype, var, transition_time)
	{
		if (ttype == Transition.FromOldSelection) {
			draw();
		}
	}

	function key_detect(signal_str)
	{
		switch (signal_str)
		{
			case "down"   : this.down_action()   ; break;
			case "up"     : this.up_action()     ; break;
			default:
				return false;
		}
		return true;
	}

	# We use this callback to move trough menu buttons when a key is hold
	down_hold_start = 0; up_hold_start = 0;
	function ticks_callback( tick_time ) 
	{
		# Don't register keys if we're not active
		if (! this.is_active) { return; }

		if (fe.get_input_state("down")) { 
			if (down_hold_start == 0) {
				down_hold_start = tick_time + 500;
			}

			if (tick_time - down_hold_start > 100) {
				down_hold_start = tick_time;
				this.key_detect("down");
			}
		} else {
			down_hold_start = 0;
		}

		if (fe.get_input_state("up")) { 
			if (up_hold_start == 0) {
				up_hold_start = tick_time + 500;
			}

			if (tick_time - up_hold_start > 100) {
				up_hold_start = tick_time;
				this.key_detect("up");
			}
		} else {
			up_hold_start = 0;
		}
	}

	function draw()
	{
		# Sidebox Border
		this.border_image.visible = this.is_active;

		# Connection Bar Image
		if (this.is_active) {
			this.connection_bar.file_name = "images/connection_bar_active.png";
		} else {
			this.connection_bar.file_name = "images/connection_bar_inactive.png";
		}

		# Connection Bar Location
		this.connection_bar.y = 340 + (fe.list.index % 6) * 130;

		# Overview Text
		this.overview_text.msg = short_overview();
		this.overview_shadow.msg = this.overview_text.msg;
	}

	function down_action()
	{
	}

	function up_action()
	{
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