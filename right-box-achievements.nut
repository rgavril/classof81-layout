class AchievementEntry {
	achievement = null

	surface = null;
	badge_icon = null;
	title_label = null;
	description_label = null;
	selection_box = null;
	is_selected = false;

	description_scroller = null;
	title_scroller = null;

	m_desaturize_shader = null;
	m_empty_shader = null;

	constructor(surface, x, y)
	{
		# Surface that we draw on
		this.surface = surface.add_surface(460, 350);
		this.surface.set_pos(x, y);

		# Achievement selection box
		this.selection_box = this.surface.add_image("images/achievement_selected.png", 0, 0);
		this.selection_box.visible = false;
		this.selection_box.alpha = 200;

		# Achievemnt badge image
		this.badge_icon = this.surface.add_image(null, 15, 5);
		this.badge_icon.height=55;
		this.badge_icon.width=55;


		# Location of description and title text
		local text_x = 85;
		local text_y = 13;

		# Title of the achievement
		this.title_label = this.surface.add_text("", text_x, text_y, 340, 85);
		this.title_label.char_size = 24;
		this.title_label.align = Align.TopLeft;
		this.title_label.margin = 0;
		this.title_label.set_rgb(255,252,103);

		this.title_scroller = TextScroller(this.title_label, "");

		# Description of the achievement
		this.description_label = this.surface.add_text("", text_x, text_y + 25 , 340, 40);
		this.description_label.char_size = 18;
		this.description_label.align = Align.TopLeft;
		this.description_label.margin = 0;

		this.description_scroller = TextScroller(this.description_label, "");

		# Shader used for desaturating badge icon
		m_desaturize_shader = fe.add_shader(Shader.Fragment, "shaders/desaturate.glsl");
		m_empty_shader = fe.add_shader(Shader.Empty);
	}


	function set_achievement(achievement)
	{
		this.achievement = achievement;
		draw();
		this.surface.visible = true;
	}

	function set_badge(filename)
	{
		this.badge_icon.file_name = filename;
	}

	function hide()
	{
		this.surface.visible = false;
	}

	function draw()
	{
		if ("DateEarned" in achievement) {
			this.badge_icon.shader = m_empty_shader;
		} else {
			this.badge_icon.shader = m_desaturize_shader;
		}

		# Update the title and description
		this.description_scroller.set_text(this.achievement.Description)
		this.title_scroller.set_text(this.achievement.Title)

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

function coroutine_load_achievements(rom) {
	suspend(null);

	# Download Game Info
	try {
		ra.download_gameinfo(rom);
	} catch (error) {
		return {"error": error }
	}
	suspend(null);

	# Parse Game Info
	local gameinfo = null;
	try {
		gameinfo = ra.parse_gameinfo(rom);
	} catch (error) {
		return {"error": error }
	}
	suspend(null);


	print_table(gameinfo);

	# Download Badges
	if ("Achievements" in gameinfo) {
		foreach (achievement in gameinfo.Achievements) {
			ra.badge_image(achievement["BadgeName"])
			suspend(null);
		}

		# Return the achivements part of the gameinfo as an array
		local achievements = [];
		foreach (key, value in gameinfo.Achievements) {
		    achievements.append(value);
		}

		return {"achievements" : achievements};
	}

	return { "achievements": [] };
}

class RightBoxAchievements
{	
	surface = null;    # Drawing Surface
	message = null;    # 
	entries = [];      # Array of AchievementEntries

	achievements = []; # Array containing all the achivements
	select_idx = 0;    # The index of the selected achivement
	offset_idx = 0;    # The index of the first visible achivement

	PAGE_SIZE = 10;    # Number of achievemnts visible on screen
	is_active = true;

	last_rom_update = "";

	function constructor()
	{
		# Drawing Sufrace
		this.surface = fe.add_surface(450, 840);
		this.surface.x  = 475;
		this.surface.y  = 235;

		# Snap Fade
		this.surface.add_image("images/test.png", 0, 0);

		# Title Shadow
		local title_shadow = this.surface.add_text("Retro Achievements", 25+1, 10+1, this.surface.width-50, 50)
		title_shadow.font = "fonts/CriqueGrotesk-Bold.ttf"
		title_shadow.set_rgb(0,0,0)
		title_shadow.char_size = 32
		title_shadow.align = Align.TopCentre

		# Title
		local title = this.surface.add_text("Retro Achievements", 25, 10, this.surface.width-50, 50)
		title.font = "fonts/CriqueGrotesk-Bold.ttf"
		title.set_rgb(255,104,181);
		title.char_size = 32;
		title.align = Align.TopCentre;

		# Message
		this.message = this.surface.add_text("", 30, 200, this.surface.width-60, 320);
		this.message.char_size = 30;
		this.message.line_spacing = 1.2;
		this.message.align = Align.MiddleCentre;
		this.message.word_wrap = true;
		this.message.visible = false;

		# Create the achievement entries
		this.entries = [];
		for (local i=0; i<PAGE_SIZE; i++) {
			local entry = AchievementEntry(this.surface, 0, 85+70*i);
			this.entries.push(entry)
		}

		fe.add_ticks_callback(this, "async_load_update");

		draw();
	}

	async_load_thread = newthread(coroutine_load_achievements);
	function async_load_update(tick_time)
	{
		if (this.async_load_thread.getstatus() == "suspended") {
			local response = this.async_load_thread.wakeup();

			if (response != null) {
				if ("error" in response) {
					this.set_achievements([]);
					this.show_message(response.error);
				}

				if ("achievements" in response) {
					# Update Achivements
					this.set_achievements(response.achievements);
				}
			}
		}

		if (this.async_load_thread.getstatus() == "idle" && this.is_active) {
			if (fe.game_info(Info.Name) != last_rom_update) {
				this.last_rom_update = fe.game_info(Info.Name);
				this.async_load_thread.call(last_rom_update);
			}
		}
	}

	function key_detect(signal_str)
	{
		if (!this.is_active) { return }
		
		if (signal_str == "down") {
			this.down_action();
			return true;
		}

		if (signal_str == "up" ) {
			this.up_action();
			return true;
		}

		if (signal_str == "select") {
			return true;
		}

		return false;
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

	function set_achievements(achievements)
	{
		# Update achievements
		this.achievements = achievements;

		# Sort Achievements by ID
		this.achievements.sort(@(a, b) a.ID <=> b.ID);

		# Redraw
		this.draw();
	}

	function draw()
	{
		if (! this.is_active) {
			return;
		}

		# Update the instrutions bottom text
		bottom_text.set("Move up or down to browse the Achievements. Move left to play [Title] or a different game.");

		if (fe.game_info(Info.Name) != last_rom_update || this.async_load_thread.getstatus() == "suspended") {
			this.show_message("Loading ...");
			return;
		} else {
			this.hide_message();
		}

		if (this.achievements.len() == 0)
		{
			this.show_message("Game Has No Retro Achivements");
		}

		for (local i=0; i<PAGE_SIZE; i++) {
			local entry = this.entries[i];
			local visible_idx = this.offset_idx + i;

			# Hide achivement entry if it points to a non existing achivement
			if (visible_idx >= this.achievements.len()) {
				entry.hide();
				continue;
			}

			entry.set_achievement(this.achievements[visible_idx]);
			entry.set_badge(ra.badge_image(this.achievements[visible_idx]["BadgeName"]));

			# Mark entry as selected, but only when the achivements are active
			if (this.is_active && this.select_idx == visible_idx) {
				entry.select()
			} else {
				entry.deselect();
			}
		}
	}

	function down_action()
	{
		# If we're at the end of the list, no need to move forward
		if (this.select_idx == this.achievements.len() - 1) {
			return;
		}


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
		this.is_active = true;
		this.surface.visible = true;
		// this.load();
		this.draw();
	}

	function desactivate()
	{
		this.is_active = false;
		this.surface.visible = false;
	}
}