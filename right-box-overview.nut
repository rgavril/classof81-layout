local right_box_button_data = [
	{
		"type": "achievement",
		"title": "Retro Achievements",
		"description": "Unlocked 13/24"
	},
	{
		"type": "leaderboard",
		"title": "Ms. Normal Score",
		"description": "37,160 (Rank 73)"
	},
	{
		"type": "leaderboard",
		"title": "High Score: Hard Difficulty",
		"description": "20,120 (Rank 10)"
	}
]

function async_load_right_box_button_data(rom) {
	right_box_button_data = [];

	local game_id = ra.game_id(rom);

	// Achievements
	local user_game_progress = ra.GetGameInfoAndUserProgress(game_id);
	local data = {
		"type": "achievements",
		"title": "Retro Achievements",
		"description": format("%s Unlocked %d of %d", user_game_progress["UserCompletion"], user_game_progress["NumAwardedToUser"] ,user_game_progress["NumAchievements"])
	}
	right_box_button_data.push(data);

	// Leaderboards
	local game_leaderboards = ra.GetGameLeaderboards(game_id);

	local user_leaderboards = null;
	try {
		user_leaderboards = ra.GetUserGameLeaderboards(game_id);
	} catch(e) {
	}

	if ("Results" in game_leaderboards) {
		foreach (game_leaderboard in game_leaderboards["Results"]) {
			local data = {
				"type": "leaderboard",
				"title": game_leaderboard["Title"],
				"description" : "No Score Registered"
			}

			if ("Results" in user_leaderboards) {
				foreach(user_leaderboard in user_leaderboards["Results"]) {
					if (user_leaderboard["ID"] == game_leaderboard["ID"]) {
						local user_entry = user_leaderboard["UserEntry"];
						data["description"] = format("Rank %d with Score %s", user_entry["Rank"], user_entry["FormattedScore"]);
					}
				}
			}

			right_box_button_data.push(data);
		}
	}
}

class RightBoxOverview
{
	surface = null;
	overview_text = null;
	overview_shadow = null;
	buttons = [];

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
		this.overview_shadow = this.surface.add_text("", 2, 85+2, 450, this.surface.height-65);
		this.overview_shadow.align = Align.TopLeft;
		this.overview_shadow.char_size = 26;
		this.overview_shadow.word_wrap = true;
		this.overview_shadow.margin = 20;
		this.overview_shadow.set_rgb(0, 0, 0);

		this.overview_text = this.surface.add_text("", 0, 85, 450, this.surface.height-65);
		this.overview_text.align = Align.TopLeft;
		this.overview_text.char_size = 26;
		this.overview_text.word_wrap = true;
		this.overview_text.margin = 20;
		this.overview_text.set_rgb(255, 252, 103);

		# Buttons
		// for (local i=0; i < 11; i++) {
		// 	local button = RightBoxOverviewButton(this.surface, 0, 75+i*65);
		// 	this.buttons.push(button);
		// }

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

		// async_load_right_box_button_data(diversions.get(fe.game_info(Info.Name)));

		// foreach (idx, button in this.buttons) {
		// 	if (idx >= right_box_button_data.len()) {
		// 		button.hide();
		// 		continue;
		// 	}

		// 	local data = right_box_button_data[idx];
		// 	button.set_title(data["title"]);
		// 	button.set_description(data["description"]);
		// 	button.set_icon(data["type"]);
		// 	button.show();
		// }

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

class RightBoxOverviewButton {
	surface = null;
	title = null;
	description = null;
	icon = null;

	constructor(parent_surface, x, y) {
		this.surface = parent_surface.add_surface(450-20, 60);
		this.surface.x = x+10;
		this.surface.y = y;

		local rectangle = this.surface.add_rectangle(0, 0, this.surface.width, this.surface.height);
		rectangle.set_rgb(0, 0, 0);
		rectangle.alpha = 100;

		# Location of description and title text
		local text_x = 85;
		local text_y = 10;

		# Title
		this.title = this.surface.add_text("Title", text_x, text_y, 340, 85);
		this.title.char_size = 24;
		this.title.align = Align.TopLeft;
		this.title.margin = 0;
		this.title.set_rgb(255,252,103);

		# Description
		this.description = this.surface.add_text("Description", text_x, text_y + 25 , 340, 40);
		this.description.char_size = 18;
		this.description.align = Align.TopLeft;
		this.description.margin = 0;

		# Icon
		this.icon = this.surface.add_image("", 15, 5);
		this.icon.height=50;
		this.icon.width=50;
	}

	function hide() {
		this.surface.visible = false;
	}

	function show() {
		this.surface.visible = true;
	}

	function set_title(title) {
		this.title.msg = title;
	}

	function set_description(description) {
		this.description.msg = description;
	}

	function set_icon(type) {
		this.icon.file_name = "images/"+type+"_icon.png";
	}
}