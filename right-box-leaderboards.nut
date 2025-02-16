class RightBoxLeaderboards {
	surface = null;
	is_active = false;

	subtitle = null;
	subtitle_scroller = null;
	title = null;
	title_shadow = null;
	
	entries = [];
	PAGE_SIZE = 24;

	constructor()
	{
		this.surface = fe.add_surface(450, 840);
		this.surface.x       = 475;
		this.surface.y       = 235;
		this.surface.visible = this.is_active;

		# Snap Fade
		this.surface.add_image("images/test.png", 0, 0);

		# Title Shadow
		this.title_shadow = this.surface.add_text("Leaderboards", 25+1, 10+1, this.surface.width-50, 50)
		this.title_shadow.font = "fonts/CriqueGrotesk-Bold.ttf"
		this.title_shadow.set_rgb(0,0,0)
		this.title_shadow.char_size = 32
		this.title_shadow.align = Align.TopCentre

		# Title
		this.title = this.surface.add_text("Leaderboards", 25, 10, this.surface.width-50, 50)
		this.title.font = "fonts/CriqueGrotesk-Bold.ttf"
		this.title.set_rgb(255,104,181);
		this.title.char_size = 32;
		this.title.align = Align.TopCentre;

		# Subtitle
		this.subtitle = this.surface.add_text("", 25, 50, this.surface.width-50, 50);
		subtitle.font = "fonts/CriqueGrotesk.ttf"
		subtitle.set_rgb(255, 255, 255);
		subtitle.char_size = 24;
		subtitle.align = Align.TopCentre;

		this.subtitle_scroller = TextScroller(this.subtitle, "");
		this.subtitle_scroller.activate();

		# Entries
		this.entries = [];
		for (local i=0; i<PAGE_SIZE; i++) {
			local entry = LeaderboardEntry(this.surface, 0, 105+30*i);
			this.entries.push(entry)
		}

	}

	function rom_current()
	{
		return diversions.get(fe.game_info(Info.Name));
	}

	function draw()
	{
		local rom = this.rom_current();

		local game_id = ra.game_id(rom);

		local leaderboards = ra.GetGameLeaderboards(game_id);
		var_dump(leaderboards);

		this.title.msg = leaderboards["Results"][0]["Title"];
		this.title_shadow.msg = leaderboards["Results"][0]["Title"];
		this.subtitle_scroller.set_text(leaderboards["Results"][0]["Description"]);

		local leaderboard_id = leaderboards["Results"][0]["ID"];
		local leaderboard = ra.GetLeaderboardEntries(leaderboard_id, 0, this.PAGE_SIZE);
		var_dump(leaderboard);

		for (local i=0; i<PAGE_SIZE; i++) {
			local entry = this.entries[i];
			entry.set_data(leaderboard["Results"][i]);
		}
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

class LeaderboardEntry
{
	surface = null;
	rank = null;
	name = null;
	score = null;

	data = null;

	constructor(surface, x, y) {
		# Surface that we draw on
		this.surface = surface.add_surface(460, 100);
		this.surface.set_pos(x, y);

		this.rank = this.surface.add_text("Rank", 20, 0, 340, 40);
		this.rank.char_size = 25;
		this.rank.align = Align.TopLeft;
		this.rank.margin = 0;
		this.rank.set_rgb(255,252,103);

		this.name = this.surface.add_text("name", 80, 0, 340, 40);
		this.name.char_size = 25;
		this.name.align = Align.TopLeft;
		this.name.margin = 0;
		this.name.set_rgb(255,252,103);

		this.score = this.surface.add_text("score", 0, 0, 450-20, 40);
		this.score.char_size = 25;
		this.score.align = Align.TopRight;
		this.score.margin = 0;
		this.score.set_rgb(255,252,103);

		// this.surface.add_rectangle(340, 0, 100, 40);
	}

	function set_data(data)
	{
		this.data = data;
		this.draw();
	}

	function draw()
	{
		this.rank.msg = data["Rank"];
		this.name.msg = data["User"];
		this.score.msg = data["FormattedScore"];
	}
}