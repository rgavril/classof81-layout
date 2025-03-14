local RightBoxLeaderboards_AsyncData = {
	"rom" : "",
	"error": "",
	"leaderboards": [
		{
			"title": "Ms. Normal Score",
			"description": "This is a description",
			"rank": 5,
			"score": "123,456"
		},
		{
			"title": "High Score: Hard Difficulty",
			"description": "This is another description"
		}
	]
};

function RightBoxLeaderboards_AsyncData_Load(rom) {
	suspend(null);

	RightBoxLeaderboards_AsyncData["rom"] = rom;
	RightBoxLeaderboards_AsyncData["leaderboards"] = [];
	RightBoxLeaderboards_AsyncData["error"] = "";

	suspend(null);

	local game_id = 0;
	try {
		game_id = ra.game_id(rom);
	} catch(e) {
		RightBoxLeaderboards_AsyncData["error"] = e;
		return null;
	}
	suspend(null);

	// Game Leaderboards
	local game_leaderboards = ra.GetGameLeaderboards(game_id);
	suspend(null);

	// User Leaderboards
	local user_leaderboards = null;
	try {
		user_leaderboards = ra.GetUserGameLeaderboards(game_id);
	} catch(e) {
	}
	suspend(null);

	if ("Results" in game_leaderboards) {
		foreach (game_leaderboard in game_leaderboards["Results"]) {
			local data = {
				"id"         : game_leaderboard["ID"],
				"title"      : game_leaderboard["Title"],
				"description": game_leaderboard["Description"],
			}

			if ("Results" in user_leaderboards) {
				foreach(user_leaderboard in user_leaderboards["Results"]) {
					if (user_leaderboard["ID"] == game_leaderboard["ID"]) {
						local user_entry = user_leaderboard["UserEntry"];
						data["rank"] <- user_entry["Rank"];
						data["score"] <- user_entry["FormattedScore"];
					}
				}
			}

			RightBoxLeaderboards_AsyncData["leaderboards"].push(data);
		}
	}
}

class RightBoxLeaderboards {
	surface = null;
	is_active = false;
	is_loading = false;

	subtitle = null;
	title = null;
	message = null;
	
	entries = [];
	PAGE_SIZE = 10;

	leaderboard_idx = 0;
	last_romchange_time = 0;

	select_idx = 0;    # The index of the selected leaderboard
	offset_idx = 0;    # The index of the first visible leaderboard

	leaderboard_dispay = null;

	constructor()
	{
		this.surface = fe.add_surface(450, 840);
		this.surface.x       = 475;
		this.surface.y       = 235;
		this.surface.visible = this.is_active;

		# Title
		this.title = this.surface.add_text("Leaderboards", 25, 10, this.surface.width-50, 50)
		this.title.font = "fonts/CriqueGrotesk-Bold.ttf"
		this.title.set_rgb(255,104,181);
		this.title.char_size = 32;
		this.title.align = Align.TopCentre;
		TextShadow(this.surface, this.title);

		# Subtitle
		this.subtitle = this.surface.add_text("", 25, 50, this.surface.width-50, 50);
		subtitle.font = "fonts/CriqueGrotesk.ttf"
		subtitle.set_rgb(255, 255, 255);
		subtitle.char_size = 24;
		subtitle.align = Align.TopCentre;
		TextShadow(this.surface, this.subtitle);

		# Message
		this.message = this.surface.add_text("", 30, 250, this.surface.width-60, 320);
		this.message.font = "fonts/CriqueGrotesk.ttf"
		this.message.char_size = 28;
		this.message.line_spacing = 1.2;
		this.message.align = Align.MiddleCentre;
		this.message.word_wrap = true;
		this.message.visible = false;
		this.message.set_rgb(255, 252, 103);
		TextShadow(this.surface, this.message);

		# Entries
		this.entries = [];
		for (local i=0; i<PAGE_SIZE; i++) {
			local entry = RightBoxLeaderboardsEntry(this.surface, 0, 105+70*i);
			this.entries.push(entry)
		}

		# Display
		this.leaderboard_dispay = RightBoxLeaderboard();

		fe.add_ticks_callback(this, "async_load_manager");
		fe.add_transition_callback(this, "transition_callback");
	}

	async_load_thread = newthread(RightBoxLeaderboards_AsyncData_Load)
	function async_load_manager(tick_time) {
		// Continue Suspended Threads
		if (this.async_load_thread.getstatus() == "suspended") {
			this.async_load_thread.wakeup();

			// If the last wakeup finished the job
			if (this.async_load_thread.getstatus() == "idle") {
				this.is_loading = false;
				this.draw();
			}
		}

		// Determine if we need to run a thread
		local need_reload = false;
		if (RightBoxLeaderboards_AsyncData["rom"] != this.rom_current()) {
			need_reload = true;
		}

		if (this.async_load_thread.getstatus() == "idle" && need_reload && this.surface.visible) {
			this.is_loading = true;
			this.offset_idx = 0;
			this.select_idx = 0;

			if (this.last_romchange_time + 600 < fe.layout.time) {
				this.async_load_thread.call(this.rom_current());
			}

			draw();
		}
	}

	function transition_callback(ttype, var, transition_time)
	{
		# Force a leaderboards reload when returning from the game
		if (ttype == Transition.FromGame && this.surface.visible) {
			RightBoxLeaderboards_AsyncData["rom"] = "";
		}

		if (ttype == Transition.ToNewSelection) {
			this.last_romchange_time = fe.layout.time;
		}

		if (ttype == Transition.FromOldSelection) {
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

		# Update the Subtitle
		this.subtitle.msg = romlist.game_info(this.rom_current(), Info.Title);

		# If the data is still loading
		if (this.is_loading == true) {
			this.show_message("Loading ...");
			return;
		}

		# If the data loaaing found a error
		if (RightBoxLeaderboards_AsyncData["error"] != "") {
			this.show_message(RightBoxLeaderboards_AsyncData["error"]);
			return;
		}

		# Update the Entries
		local leaderboards = RightBoxLeaderboards_AsyncData["leaderboards"];

		if (leaderboards.len() == 0) {
			this.show_message("No Leaderboards Found!");
		} else {
			this.hide_message();
		}

		# Update all leaderboard entries
		for (local i=0; i<PAGE_SIZE; i++) {
			local entry = this.entries[i];
			local visible_idx = this.offset_idx + i;

			if (visible_idx >= leaderboards.len()) {
				entry.hide();
				continue;
			}

			entry.set_data(leaderboards[visible_idx]);
			entry.show();

			if (this.is_active && this.select_idx == visible_idx) {
				entry.select()
			} else {
				entry.deselect();
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
		if (! this.is_active) { return }

		if ( this.leaderboard_dispay.is_active ) {
			if (this.leaderboard_dispay.key_detect(signal_str)) {
				return true;
			}
		}

		if (signal_str == "down") {
			this.down_action();
			return true;
		}

		if (signal_str == "up" ) {
			this.up_action();
			return true;
		}

		if (signal_str == "select") {
			local leaderboard = RightBoxLeaderboards_AsyncData["leaderboards"][select_idx];
		
			this.leaderboard_dispay.set_leaderboard_id(leaderboard["id"]);
			this.leaderboard_dispay.set_leaderboard_title(leaderboard["title"]);
			this.leaderboard_dispay.set_leaderboard_description(leaderboard["description"]);
			this.leaderboard_dispay.show();

			this.hide();

			return true;
		}

		return false;
	}

	function down_action()
	{
		# If we're at the end of the list, no need to move forward
		if (this.select_idx == RightBoxLeaderboards_AsyncData["leaderboards"].len() - 1) {
			return;
		}

		# Play a sound
		::sound_engine.play_click_sound()

		# Select the next element in list
		this.select_idx++;

		# Scroll the list down if the selection is not visible
		if (this.select_idx > this.offset_idx + (PAGE_SIZE - 1)) {
			this.offset_idx++;
		}

		this.draw();
	}

	function up_action()
	{
		# If we're at the begining of the list, no need to move back
		if (this.select_idx == 0) {
			return;
		}

		# Play a sound
		::sound_engine.play_click_sound()

		# Select the previous element in the list
		this.select_idx--;

		# Scroll the list up if the selection is not visible
		if (this.select_idx < this.offset_idx) {
			this.offset_idx--;
		}

		this.draw();
	}

	function activate()
	{
		::bottom_text.set("Move up or down to browse the Leaderboards. Move left to play [Title] or a different game. Move right to view game description.");
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

class RightBoxLeaderboardsEntry
{
	data = null;

	surface = null;
	icon_border = null;
	icon_background = null;
	title_label = null;
	title_scroller = null;
	description_label = null;
	description_scroller = null;
	rank_label = null;
	score_label = null;
	selection_box = null;

	is_selected = false;

	constructor(surface, x, y) {
		# Surface that we draw on
		this.surface = surface.add_surface(460, 350);
		this.surface.set_pos(x, y);

		# Selection box
		this.selection_box = this.surface.add_image("images/achievement_selected.png", 0, 0);
		this.selection_box.visible = false;
		this.selection_box.alpha = 200;

		# Badge image border
		this.icon_border = this.surface.add_rectangle(15, 5, 55, 55);
		this.icon_border.set_rgb(0x90, 0xac, 0xbf);
		this.icon_border.outline = 0;
		this.icon_border.set_outline_rgb(0x90, 0xac, 0xbf); //90 AC BF
		this.icon_border.alpha = 0;

		this.icon_background = this.surface.add_image("images/leaderboard_icon.png",15,5,55,55);

		this.rank_label = this.surface.add_text("Rank", this.icon_border.x, this.icon_border.y+6, 55, 20);
		this.rank_label.margin = 0;
		this.rank_label.align = Align.MiddleCentre;
		this.rank_label.char_size = 20;
		// this.rank_label.font = "fonts/RobotoCondensed-SemiBold.ttf"
		this.rank_label.set_rgb(255,255,255);
		TextShadow(this.surface, this.rank_label);

		this.score_label = this.surface.add_text("Score", this.icon_border.x, this.icon_border.y + 37, 55, 14);
		this.score_label.margin = 0;
		this.score_label.align = Align.MiddleCentre;
		this.score_label.char_size = 14;
		// this.score_label.font = "fonts/RobotoCondensed-Regular.ttf"
		this.score_label.set_rgb(0, 0, 0);

		# Location of description and title text
		local text_x = 85;
		local text_y = 13;

		# Title
		this.title_label = this.surface.add_text("Title", text_x, text_y, 340, 85);
		this.title_label.char_size = 24;
		this.title_label.align = Align.TopLeft;
		this.title_label.margin = 0;
		this.title_label.set_rgb(255,252,103);
		this.title_scroller = TextScroller(this.title_label, this.title_label.msg);
		TextShadow(this.surface, this.title_label);

		# Description
		this.description_label = this.surface.add_text("Description", text_x, text_y + 25 , 340, 40);
		this.description_label.char_size = 18;
		this.description_label.align = Align.TopLeft;
		this.description_label.margin = 0;

		this.description_scroller = TextScroller(this.description_label, this.description_label.msg);
		TextShadow(this.surface, this.description_label);
	}

	function set_data(data)
	{
		this.data = data;
		this.draw();
	}

	function draw()
	{
		if ("title" in this.data) {
			this.title_scroller.set_text(this.data["title"]);
		}

		if ("description" in this.data) {
			this.description_scroller.set_text(this.data["description"]);
		}

		if ("rank" in this.data && "rank" in this.data) {
			this.rank_label.msg = this.data["rank"];
			this.score_label.msg = this.data["score"];

			switch(this.data["rank"] % 10) {
				case 1:
					this.rank_label.msg += this.data["rank"] != 11 ? "st" : "th";
					break;
				case 2:
					this.rank_label.msg += this.data["rank"] != 12 ? "nd" : "th";
					break;
				case 3:
					this.rank_label.msg += this.data["rank"] != 13 ? "rd" : "th";
					break;
				default:
					this.rank_label.msg += "th";
					break;
			}
		} else {
			this.rank_label.msg = "NO";
			this.score_label.msg = "Score";
		}

		if (this.is_selected) {
			this.selection_box.visible = true;
			this.description_scroller.activate();
			this.title_scroller.activate();
		} else {
			this.selection_box.visible = false;
			this.description_scroller.desactivate();
			this.title_scroller.desactivate();
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

	function select()
	{
		this.is_selected = true;
		this.draw()
	}

	function deselect()
	{	
		this.is_selected = false;
		this.draw()
	}
}