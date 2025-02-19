local ldb_data = {
	// Inputs
	"rom": "",
	"current_page": -1,
	"leaderboard_idx": -1,

	// Outputs
	"game_id": null,
	"game_leaderboards": null,
	"game_leaderboards_count": 0,
	"user_leaderboards": null,

	"game_leaderboard_id": null,
	"game_leaderboard_title": "",
	"game_leaderboard_description": "",
	"game_leaderboard_total": 0,
	"game_leaderboard_entries": null,

	// Stats
	"is_loading" : true,
	"error": ""

}

function ldb_data_update(rom, leaderboard_idx, current_page, page_size) {
	ldb_data["is_loading"] = true;
	ldb_data["error"] = "";
	ldb_data["leaderboard_idx"] = leaderboard_idx;
	ldb_data["current_page"] = current_page;
	suspend(null);

	// If rom changed reset everything
	if (rom != ldb_data["rom"]) {
		ldb_data["rom"] = rom;
		
		// Get Game ID
		try {
			ldb_data["game_id"] = ra.game_id(rom);
		} catch(error) {
			ldb_data["error"] = error;
			ldb_data["is_loading"] = false;
			return;
		}
		suspend(null);

		// Get Game Leaderboards
		try {
			ldb_data["game_leaderboards"] = ra.GetGameLeaderboards(ldb_data["game_id"]);
		} catch(error) {
			ldb_data["error"] = "error";
			ldb_data["is_loading"] = false;
			return;
		}
		suspend(null);

		// Get User Leaderboards
		try {
			ldb_data["user_leaderboards"] = ra.GetUserGameLeaderboards(ldb_data["game_id"]);
		} catch(error) {
			ldb_data["user_leaderboards"] = null;
		}
		suspend(null);

		ldb_data["game_leaderboard_entries"] = null;
		ldb_data["game_leaderboards_count"] = ldb_data["game_leaderboards"]["Results"].len();
	}

	if (ldb_data["game_leaderboards_count"] == 0) {
		ldb_data["error"] = "Game has no leaderboards.";
		ldb_data["is_loading"] = false;
		return;
	}

	if (leaderboard_idx >= ldb_data["game_leaderboards_count"]) {
			ldb_data["error"] = "Leaderbord index out of bounds.";
			ldb_data["is_loading"] = false;
			return;
	}

	ldb_data["game_leaderboard_id"] = ldb_data["game_leaderboards"]["Results"][leaderboard_idx]["ID"];
	ldb_data["game_leaderboard_title"] = ldb_data["game_leaderboards"]["Results"][leaderboard_idx]["Title"];
	ldb_data["game_leaderboard_description"] = ldb_data["game_leaderboards"]["Results"][leaderboard_idx]["Description"];

	// Retrive leaderboard entries
	local leaderboard_entries = null;
	try {
		 leaderboard_entries = ra.GetLeaderboardEntries(ldb_data["game_leaderboard_id"], (current_page-1)*page_size, page_size);
	} catch(error) {
		ldb_data["error"] = error;
		ldb_data["is_loading"] = false;
		return;
	}
	suspend(null);

	ldb_data["game_leaderboard_total"] = leaderboard_entries["Total"];
	ldb_data["game_leaderboard_entries"] = leaderboard_entries["Results"];

	// See if the user has a score in this leaderboard
	local user_entry = null;
	if ("Results" in ldb_data["user_leaderboards"]) {
		foreach (result in ldb_data["user_leaderboards"]["Results"]) {
			if (result["ID"] == ldb_data["game_leaderboard_id"]) {
				user_entry = result["UserEntry"];
			}
		}
	}

	// See if the user it's displayed in the current leaerboard entries
	local user_found = false;
	foreach (entry in ldb_data["game_leaderboard_entries"]) {
		if (entry["User"] == AM_CONFIG["ra_username"])  {
			user_found = true;
			break;
		}
	}

	// If user has a entry but is not displayed, add it at in the list
	if (user_entry && !user_found) {
		local empty_entry = {
			"FormattedScore": "",
			"User": "",
			"Rank": "..."
		};
		
		if (user_entry["Rank"] < ldb_data["game_leaderboard_entries"][0]["Rank"] ) {
			ldb_data["game_leaderboard_entries"][0] = user_entry;
			ldb_data["game_leaderboard_entries"][1] = empty_entry;
		} else {
			ldb_data["game_leaderboard_entries"][ldb_data["game_leaderboard_entries"].len()-2] = empty_entry;
			ldb_data["game_leaderboard_entries"][ldb_data["game_leaderboard_entries"].len()-1] = user_entry;
		}
	}

	ldb_data["is_loading"] = false;
}

class RightBoxLeaderboards {
	surface = null;
	is_active = false;

	subtitle = null;
	subtitle_scroller = null;
	title = null;
	title_shadow = null;
	message = null;
	
	entries = [];
	PAGE_SIZE = 24;

	current_page = 1;
	leaderboard_idx = 0;
	last_romchange_time = 0;

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

		# Message
		this.message = this.surface.add_text("", 30, 250, this.surface.width-60, 320);
		this.message.font = "fonts/CriqueGrotesk.ttf"
		this.message.char_size = 28;
		this.message.line_spacing = 1.2;
		this.message.align = Align.MiddleCentre;
		this.message.word_wrap = true;
		this.message.visible = false;

		# Entries
		this.entries = [];
		for (local i=0; i<PAGE_SIZE; i++) {
			local entry = LeaderboardEntry(this.surface, 0, 105+30*i);
			this.entries.push(entry)
		}

		fe.add_ticks_callback(this, "async_load_manager");
		fe.add_transition_callback(this, "transition_callback");
	}

	async_load_thread = newthread(ldb_data_update);
	function async_load_manager(tick_time) {
		if (this.async_load_thread.getstatus() == "suspended") {
			this.async_load_thread.wakeup();

			if (this.async_load_thread.getstatus() == "idle") {
				this.draw();
			}
		}

		local need_reload = false;
		if (ldb_data["current_page"] != this.current_page) {
			need_reload = true;
		}
		if (ldb_data["rom"] != this.rom_current()) {
			need_reload = true;
		}
		if (ldb_data["leaderboard_idx"] != this.leaderboard_idx) {
			need_reload = true;
		}

		if (this.async_load_thread.getstatus() == "idle" && need_reload) {
			ldb_data["is_loading"] = true;
			if (this.last_romchange_time + 300 < fe.layout.time) {
				this.async_load_thread.call(this.rom_current(), this.leaderboard_idx, this.current_page, this.PAGE_SIZE);
			}
			draw();
		}
	}

	function transition_callback(ttype, var, transition_time)
	{
		if (ttype == Transition.ToNewSelection) {
			this.leaderboard_idx = 0;
			this.current_page = 1;
			this.last_romchange_time = fe.layout.time;
		}

		if (ttype == Transition.FromOldSelection) {
			this.title.msg = "Leaderboards";
			this.title_shadow.msg = this.title.msg;
			this.subtitle_scroller.set_text(romlist.game_info(this.rom_current(), Info.Title));
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

		if (ldb_data["is_loading"] == true) {
			this.show_message("Loading ...");
			return;
		} else if (ldb_data["error"] != "") {
			this.show_message(ldb_data["error"]);
			return;
		} else {
			this.hide_message();
		}

		# Update the Title
		this.title.msg        = ldb_data["game_leaderboard_title"];
		this.title_shadow.msg = this.title.msg;

		# Update the Subtitle
		this.subtitle_scroller.set_text(ldb_data["game_leaderboard_description"]);

		# Update the Entries
		local leaderboard_entries = ldb_data["game_leaderboard_entries"];

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

	function show_message(text)
	{
		this.message.msg     = text;
		this.message.visible = true;

		# Hide all entries
		foreach(entry in this.entries) {
			entry.hide();
		}
	}

	function hide_message()
	{
		this.message.visible = false;
	}

	function key_detect(signal_str)
	{
		if (!this.is_active) { return }

		if (signal_str == "right") {
			if (ldb_data["game_leaderboards_count"] > (this.leaderboard_idx + 1)) {
				this.leaderboard_idx += 1;
				this.current_page = 1;
				this.draw();
				return true;
			} else {
				this.leaderboard_idx = 0;
				this.current_page = 1;
				this.draw();
				return false;
			}
		}

		if (signal_str == "down") {
			if (this.current_page*this.PAGE_SIZE < ldb_data["game_leaderboard_total"]) {
				this.current_page += 1;
				this.draw();
			}
			return true;
		}

		if (signal_str == "up") {
			if (current_page > 1) {
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