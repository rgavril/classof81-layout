class RightBoxLeaderboards {
	surface = null;
	is_active = false;

	subtitle = null;
	subtitle_scroller = null;
	title = null;
	title_shadow = null;
	
	entries = [];
	PAGE_SIZE = 24;

	current_page = 1;

	leaderboards = null;

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

		this.leaderboards = Leaderboards(this.rom_current());

		fe.add_transition_callback(this, "transition_callback");
	}

	function transition_callback(ttype, var, transition_time)
	{
		if (ttype == Transition.FromOldSelection) {
			this.leaderboards = Leaderboards(this.rom_current());
			this.current_page = 1;
			this.draw();
		}
	}

	function rom_current()
	{
		return diversions.get(fe.game_info(Info.Name));
	}

	function draw()
	{
		if (this.surface.visible == false && this.is_active == false ) {
			return;
		}

		# Update the Title
		this.title.msg        = this.leaderboards.get_current_title();
		this.title_shadow.msg = this.title.msg;

		# Update the Subtitle
		this.subtitle_scroller.set_text(this.leaderboards.get_current_description());

		# Update the Entries
		local leaderboard_entries = leaderboards.get_current_entries(this.current_page);

		for (local i=0; i<PAGE_SIZE; i++) {
			local entry = this.entries[i];
			if (i < leaderboard_entries.len()) {
				entry.set_data(leaderboard_entries[i]);
				entry.show();
			} else {
				entry.hide();
			}
		}
	}

	function key_detect(signal_str)
	{
		if (!this.is_active) { return }

		if (signal_str == "right") {
			if (this.leaderboards.next_leaderboard()) {
				this.current_page = 1;
				this.draw();
				return true;
			} else {
				return false;
			}
		}

		if (signal_str == "down") {
			if (this.leaderboards.current_has_page(this.current_page+1)) {
				this.current_page += 1;
				this.draw();
			}
			return true;
		}

		if (signal_str == "up") {
			if (this.leaderboards.current_has_page(this.current_page-1)) {
				this.current_page -= 1;
				this.draw();
			}
			return true;
		}

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

class Leaderboards {
	rom = "";

	leaderboards = [];
	current_idx = 0;
	current_total = 0;

	page_size = 24;

	game_id = "";

	function constructor(rom)
	{
		this.rom = rom;
		this.current_idx = 0;

		this.game_id = ra.game_id(rom);
		this.leaderboards = ra.GetGameLeaderboards(game_id);
	}

	function get_current_title() {
		if (this.leaderboards["Results"].len() == 0) {
			return "Leaderboards"
		}
		
		return this.leaderboards["Results"][current_idx]["Title"];
	}

	function get_current_description() {
		if (this.leaderboards["Results"].len() == 0) {
			return "There are no leaderboards."
		}
		
		return this.leaderboards["Results"][current_idx]["Description"];
	}

	function get_current_entries(page) {
		if (this.leaderboards["Results"].len() == 0) {
			return [];
		}

		local start = (page - 1) * (this.page_size - 2);
		local count = this.page_size;

		local leaderboard_id = this.leaderboards["Results"][current_idx]["ID"];

		// Retrive leaderboard entries
		local leaderboard_entries = ra.GetLeaderboardEntries(leaderboard_id, start, count);
		this.current_total = leaderboard_entries["Total"];
		leaderboard_entries = leaderboard_entries["Results"];

		// See if the user has a score in this leaderboard
		local user_entry = null;
		try {
			// Get User Game Leaderboards
			local user_game_leaderboards = ra.GetUserGameLeaderboards(this.game_id);

			// Searh for a rank in selected leaderbord
			foreach (result in user_game_leaderboards["Results"]) {
				if (result["ID"] == leaderboard_id) {
					user_entry = result["UserEntry"];
				}
			}
		} catch (e) {
			print(e);
		}

		// See it it's displayed in the current leaerboard entries
		local user_found = false;

		foreach (entry in leaderboard_entries) {
			if (entry["User"] == AM_CONFIG["ra_username"])  {
				user_found = true;
				break;
			}
		}

		// If user has a entry but is not displayed, add it at the end
		if (user_entry && !user_found) {
			local empty_entry = {};
			empty_entry["FormattedScore"] <- "";
			empty_entry["User"]           <- "";
			empty_entry["Rank"]           <- "...";
			
			if (user_entry["Rank"] < leaderboard_entries[0]["Rank"] ) {
				leaderboard_entries[0] = user_entry;
				leaderboard_entries[1] = empty_entry;
			} else {
				leaderboard_entries[leaderboard_entries.len()-2] = empty_entry;
				leaderboard_entries[leaderboard_entries.len()-1] = user_entry;
			}
		}

		return leaderboard_entries;
	}

	function current_has_page(page) {
		if (page == 1) {
			return true;
		} else if (page < 1) {
			return false;
		} else {
			return (page-1)*this.page_size < this.current_total;
		}
	}

	function next_leaderboard() {
		if ( this.current_idx + 1 < this.leaderboards["Total"]) {
			this.current_idx = this.current_idx + 1;
			return true;
		} else {
			return false
		}
	}
}
class LeaderboardEntry
{
	surface = null;
	rank = null;
	name = null;
	score = null;
	box = null;

	data = null;

	constructor(surface, x, y) {
		# Surface that we draw on
		this.surface = surface.add_surface(460, 30);
		this.surface.set_pos(x, y);

		this.box = this.surface.add_rectangle(0,1, this.surface.width, this.surface.height-2);
		this.box.outline = 1;
		this.box.alpha = 200;
		this.box.set_rgb(100, 100, 100);
		this.box.visible = false;

		this.rank = this.surface.add_text("Rank", 20, 0, 340, 30);
		this.rank.char_size = 25;
		this.rank.align = Align.MiddleLeft;
		this.rank.font = "fonts/Roboto-Regular.ttf"
		this.rank.margin = 0;
		this.rank.set_rgb(255,252,103);

		this.name = this.surface.add_text("name", 80, 0, 340, 30);
		this.name.char_size = 25;
		this.name.align = Align.MiddleLeft;
		this.name.margin = 0;
		this.name.set_rgb(255,252,103);

		this.score = this.surface.add_text("score", 0, 0, 450-20, 30);
		this.score.char_size = 25;
		this.score.align = Align.MiddleRight;
		this.score.font = "fonts/Roboto-Regular.ttf"
		this.score.margin = 0;
		this.score.set_rgb(255,252,103);
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

		if (data["User"] == AM_CONFIG["ra_username"]) {
			this.box.visible = true;
		} else {
			this.box.visible = false;
		}
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