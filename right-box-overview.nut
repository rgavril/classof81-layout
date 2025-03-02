class RightBoxOverview
{
	surface = null;
	overview_text = null;

	is_active = false;

	constructor()
	{
		this.surface = fe.add_surface(450, 840);
		this.surface.x       = 475;
		this.surface.y       = 235;
		this.surface.visible = this.is_active;

		# Title
		local title = this.surface.add_text("[Title]", 25, 10, this.surface.width-50, 50)
		title.font = "fonts/CriqueGrotesk-Bold.ttf"
		title.set_rgb(255,104,181);
		title.char_size = 32;
		title.align = Align.TopCentre;
		TextShadow(this.surface, title);

		# Overview Short
		this.overview_text = this.surface.add_text("", 0, 65, 450, this.surface.height-65);
		this.overview_text.align = Align.TopLeft;
		this.overview_text.char_size = 26;
		this.overview_text.word_wrap = true;
		this.overview_text.margin = 20;
		this.overview_text.set_rgb(255, 252, 103);
		TextShadow(this.surface, this.overview_text);

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
		this.overview_text.msg = "";
		this.overview_text.msg += short_overview();
		this.overview_text.msg += "\n\nReleased in [Year] by [Manufacturer].";
	}

	function activate()
	{
		this.is_active = true;
		::bottom_text.set("Move left to play [Title] or a different game. Move right to view achievements.");
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