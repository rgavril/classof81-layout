class RightBoxOverview
{
	surface = null;
	overview_text = null;
	overview_shadow = null;

	is_active = false;

	constructor()
	{
		this.surface = fe.add_surface(450, 840);
		this.surface.x       = 475;
		this.surface.y       = 235;
		this.surface.visible = this.is_active;

		# Snap
		local snap = this.surface.add_artwork("snap", 0, 0);
		snap.width  = this.surface.width;
		snap.height = snap.width * 4/3;
		snap.x      = 0;
		snap.y      = this.surface.height - snap.height;

		# Snap Fade
		this.surface.add_image("images/test.png", 0, 0);

		# Title Shadow
		local title_shadow = this.surface.add_text("[Title]", 25+1, 10+1, this.surface.width-50, 50)
		title_shadow.font = "fonts/CriqueGrotesk-Bold.ttf"
		title_shadow.set_rgb(0,0,0)
		title_shadow.char_size = 32
		title_shadow.align = Align.TopCentre

		# Title
		local title = this.surface.add_text("[Title]", 25, 10, this.surface.width-50, 50)
		title.font = "fonts/CriqueGrotesk-Bold.ttf"
		title.set_rgb(255,104,181);
		title.char_size = 32;
		title.align = Align.TopCentre;

		# Overview Short
		// this.overview_shadow = fe.add_text("", 475+2, 235+65+2, 450, 840-65);
		this.overview_shadow = this.surface.add_text("", 1, 65+1, 450, this.surface.height-65);
		this.overview_shadow.align = Align.TopLeft;
		this.overview_shadow.char_size = 26;
		this.overview_shadow.word_wrap = true;
		this.overview_shadow.margin = 20;
		this.overview_shadow.set_rgb(0, 0, 0);

		this.overview_text = this.surface.add_text("", 0, 65, 450, this.surface.height-65);
		this.overview_text.align = Align.TopLeft;
		this.overview_text.char_size = 26;
		this.overview_text.word_wrap = true;
		this.overview_text.margin = 20;
		this.overview_text.set_rgb(255, 252, 103);

		# Add a callback to redraw when game is changed
		fe.add_transition_callback(this, "transition_callback");

		draw();
	}

	function transition_callback(ttype, var, transition_time)
	{
		if (ttype == Transition.FromOldSelection) {
			draw();
		}

		if (ttype == Transition.ToNewList) {
			draw();
		}
	}

	function key_detect(signal_str)
	{
		return false;
	}

	function draw() {
		if (! this.is_active) {
			return;
		}

		# Overview Text
		this.overview_text.msg = short_overview();
		this.overview_shadow.msg = this.overview_text.msg;
	}

	function activate()
	{
		this.is_active = true;
		this.draw();
	}

	function desactivate()
	{
		this.is_active = false;
		this.draw();
	}

	function show()
	{
		this.surface.visible = true;
	}

	function hide()
	{
		this.surface.visible = false;
	}
}