local RightBoxLeaderboard_AsyncData = {
	"entries": []
}

function RightBoxLeaderboard_AsyncData_Load(leaderboard_id, current_page, page_size) {
	local rom = diversions.get(fe.game_info(Info.Name));

	// User Leaderboards
	local user_leaderboards = null;
	try {
		local game_id = ra.game_id(rom);
		user_leaderboards = ra.GetUserGameLeaderboards(game_id);
	} catch(e) {
	}

	// Leaderboard Entries
	RightBoxLeaderboard_AsyncData["entries"] = [];
	try {
		local leaderboard_entries = ra.GetLeaderboardEntries(leaderboard_id, (current_page-1)*(page_size-2), page_size);
		RightBoxLeaderboard_AsyncData["entries"] = leaderboard_entries["Results"];
	} catch (e) {
		return ;
	}

	// User Entry
	local user_entry = null;
	if ("Results" in user_leaderboards) {
		foreach (user_leaderboard in user_leaderboards["Results"]) {
			if (user_leaderboard["ID"] == leaderboard_id) {
				user_entry = user_leaderboard["UserEntry"];
			}
		}
	}

	// User Found
	// See if the user it's displayed in the current leaerboard entries
	local user_found = false;
	foreach (entry in RightBoxLeaderboard_AsyncData["entries"]) {
		if (entry["User"] == AM_CONFIG["ra_username"])  {
			user_found = true;
			break;
		}
	}

	if (user_entry && !user_found) {
		local empty_entry = {
			"FormattedScore": "",
			"User": "",
			"Rank": "..."
		};
		
		if (user_entry["Rank"] < RightBoxLeaderboard_AsyncData["entries"][0]["Rank"] ) {
			RightBoxLeaderboard_AsyncData["entries"][0] = user_entry;
			RightBoxLeaderboard_AsyncData["entries"][1] = empty_entry;
		} else {
			RightBoxLeaderboard_AsyncData["entries"][RightBoxLeaderboard_AsyncData["entries"].len()-2] = empty_entry;
			RightBoxLeaderboard_AsyncData["entries"][RightBoxLeaderboard_AsyncData["entries"].len()-1] = user_entry;
		}
	}
}

class RightBoxLeaderboard {
	surface = null;
	is_active = false;

	entries = [];
	PAGE_SIZE = 24;

	current_page = 1;

	leaderboard_id = 0;

	function constructor()
	{
		this.surface = fe.add_surface(450, 840);
		this.surface.x       = 475;
		this.surface.y       = 235;
		this.surface.visible = this.is_active;

		local box = this.surface.add_rectangle(0, 0, 450, 840);
		box.set_rgb(0,64,101);

		# Entries
		this.entries = [];
		for (local i=0; i<PAGE_SIZE; i++) {
			local entry = LeaderboardEntry(this.surface, 0, 105+30*i);
			this.entries.push(entry)
		}
	}

	function key_detect(signal_str) {
		if (signal_str == "up") {
			if (this.current_page > 1) {
				this.current_page -= 1;
				this.draw();
			}
			return true;
		}

		if (signal_str == "down") {
			this.current_page += 1;
			this.draw();
			return true;
		}

		if (signal_str == "select") {
			this.hide();
			return true;
		}
	}

	function set_leaderboard_id(id) {
		this.current_page = 1;
		this.leaderboard_id = id;
	}

	function draw() {
		if (this.surface.visible == false && this.is_active == false) {
			return;
		}

		# Update the Entries
		RightBoxLeaderboard_AsyncData_Load(this.leaderboard_id, this.current_page, this.PAGE_SIZE);
		local leaderboard_entries = RightBoxLeaderboard_AsyncData["entries"];

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

	function show() {
		this.is_active = true;
		this.surface.visible = true;
		this.draw();
	}

	function hide() {
		this.is_active = false;
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

	function set_data(data) {
		this.data = data;
		this.draw();
	}

	function draw() {
		this.rank.msg = data["Rank"];
		this.name.msg = data["User"];
		this.score.msg = data["FormattedScore"];

		if (data["User"] == AM_CONFIG["ra_username"]) {
			this.box.visible = true;
		} else {
			this.box.visible = false;
		}
	}

	function show() {
		this.surface.visible = true;
	}

	function hide() {
		this.surface.visible = false;
	}
}