local RightBoxLeaderboards_AsyncData = {
	"leaderboards": [
		{
			"title": "Ms. Normal Score",
			"description": "This is a description"
		},
		{
			"title": "High Score: Hard Difficulty",
			"description": "This is another description"
		}
	]
};

function RightBoxLeaderboards_AsyncData_Load(rom) {
	RightBoxLeaderboards_AsyncData["leaderboards"] = [];

	local game_id = ra.game_id(rom);

	// Game Leaderboards
	local game_leaderboards = ra.GetGameLeaderboards(game_id);

	// User Leaderboards
	local user_leaderboards = null;
	try {
		user_leaderboards = ra.GetUserGameLeaderboards(game_id);
	} catch(e) {
	}

	if ("Results" in game_leaderboards) {
		foreach (game_leaderboard in game_leaderboards["Results"]) {
			local data = {
				"title": game_leaderboard["Title"],
				"description" : game_leaderboard["Description"]
			}

			if ("Results" in user_leaderboards) {
				foreach(user_leaderboard in user_leaderboards["Results"]) {
					if (user_leaderboard["ID"] == game_leaderboard["ID"]) {
						local user_entry = user_leaderboard["UserEntry"];
						data["rank"] <- user_entry["Rank"]
						data["score"] <- user_entry["FormattedScore"]
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

	subtitle = null;
	title = null;
	title_shadow = null;
	message = null;
	
	entries = [];
	PAGE_SIZE = 24;

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
			local entry = LeaderboardEntry(this.surface, 0, 105+70*i);
			this.entries.push(entry)
		}

		fe.add_ticks_callback(this, "async_load_manager");
		fe.add_transition_callback(this, "transition_callback");
	}

	function transition_callback(ttype, var, transition_time)
	{
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

		RightBoxLeaderboards_AsyncData_Load(this.rom_current());

		# Update the Subtitle
		this.subtitle.msg = romlist.game_info(this.rom_current(), Info.Title);

		# Update the Entries
		local leaderboards = RightBoxLeaderboards_AsyncData["leaderboards"];

		for (local i=0; i<PAGE_SIZE; i++) {
			local entry = this.entries[i];

			if (i < leaderboards.len()) {
				entry.set_data(leaderboards[i]);
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

		if (signal_str == "down") {
			return true;
		}

		if (signal_str == "up") {
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
	data = null;

	surface = null;
	icon_border = null;
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

		# Achievement selection box
		this.selection_box = this.surface.add_image("images/achievement_selected.png", 0, 0);
		this.selection_box.visible = false;
		this.selection_box.alpha = 200;

		# Achievemnt badge image border
		this.icon_border = this.surface.add_rectangle(15, 5, 55, 55);
		this.icon_border.set_rgb(0, 0, 0);
		this.icon_border.alpha = 100;
		this.icon_border.outline = 2;
		this.icon_border.set_outline_rgb(255, 255, 255); //90 AC BF
		this.icon_border.outline_alpha = 100;


		this.rank_label = this.surface.add_text("Rank", this.icon_border.x, this.icon_border.y+6, 55, 24);
		this.rank_label.margin = 0;
		this.rank_label.align = Align.MiddleCentre;
		this.rank_label.char_size = 20;
		this.rank_label.font = "fonts/RobotoCondensed-SemiBold.ttf"
		this.rank_label.set_rgb(255,252,103);

		this.score_label = this.surface.add_text("Score", this.icon_border.x, this.icon_border.y + 35, 55, 14);
		this.score_label.margin = 0;
		this.score_label.align = Align.MiddleCentre;
		this.score_label.char_size = 14;
		this.score_label.font = "fonts/RobotoCondensed-Regular.ttf"
		this.score_label.set_rgb(255,252,103);

		# Location of description and title text
		local text_x = 85;
		local text_y = 13;

		# Title of the achievement
		this.title_label = this.surface.add_text("Title", text_x, text_y, 340, 85);
		this.title_label.char_size = 24;
		this.title_label.align = Align.TopLeft;
		this.title_label.margin = 0;
		this.title_label.set_rgb(255,252,103);

		this.title_scroller = TextScroller(this.title_label, this.title_label.msg);

		# Description of the achievement
		this.description_label = this.surface.add_text("Description", text_x, text_y + 25 , 340, 40);
		this.description_label.char_size = 18;
		this.description_label.align = Align.TopLeft;
		this.description_label.margin = 0;

		this.description_scroller = TextScroller(this.description_label, this.description_label.msg);
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
			this.rank_label.msg = this.data["rank"] + "th";
			this.score_label.msg = this.data["score"];
			// this.icon_border.set_outline_rgb(255, 255, 0);
		} else {
			this.rank_label.msg = "NO";
			this.score_label.msg = "Score";
			// this.icon_border.set_outline_rgb(0x90, 0xAC, 0xBF);
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