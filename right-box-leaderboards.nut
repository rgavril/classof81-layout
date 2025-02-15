class RightBoxLeaderboards {
	surface = null;
	is_active = false;

	subtitle = null;

	constructor()
	{
		this.surface = fe.add_surface(450, 840);
		this.surface.x       = 475;
		this.surface.y       = 235;
		this.surface.visible = this.is_active;

		# Title Shadow
		local title_shadow = this.surface.add_text("Leaderboards", 25+1, 10+1, this.surface.width-50, 50)
		title_shadow.font = "fonts/CriqueGrotesk-Bold.ttf"
		title_shadow.set_rgb(0,0,0)
		title_shadow.char_size = 32
		title_shadow.align = Align.TopCentre

		# Title
		local title = this.surface.add_text("Leaderboards", 25, 10, this.surface.width-50, 50)
		title.font = "fonts/CriqueGrotesk-Bold.ttf"
		title.set_rgb(255,104,181);
		title.char_size = 32;
		title.align = Align.TopCentre;

		# Subtitle
		this.subtitle = this.surface.add_text("", 25, 50, this.surface.width-50, 50);
		subtitle.font = "fonts/CriqueGrotesk.ttf"
		subtitle.set_rgb(255, 255, 255);
		subtitle.char_size = 24;
		subtitle.align = Align.TopCentre;
	}

	function rom_current()
	{
		return diversions.get(fe.game_info(Info.Name));
	}

	function draw()
	{
		local rom = this.rom_current();
		local leaderboard_id = 0;
		local leaderboard_offset = 0;
		local leaderboard_entries = 10;

		local leaderboards = ra.parse_leaderboards(rom);
		var_dump(leaderboards);

		// local leaderboard = ra.parse_leaderboard_entries(leaderboard_id, leaderboard_offset, leaderboard_entries);
		// var_dump(leaderboard);
	}

	function key_detect(signal_str)
	{
		return false;
	}

	function activate()
	{
		this.is_active = true;
		this.draw();
	}

	function desactivate()
	{
		this.is_active = false;
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