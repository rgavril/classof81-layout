class AchievementEntry {
	achievement = null

	surface = null;
	badge_icon = null;
	badge_icon_border = null;
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

		# Achievemnt badge image border
		this.badge_icon_border = this.surface.add_rectangle(this.badge_icon.x, this.badge_icon.y, this.badge_icon.width, this.badge_icon.height);
		this.badge_icon_border.alpha = 0;
		this.badge_icon_border.outline = 2;
		this.badge_icon_border.set_outline_rgb(255,255,0);



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
		TextShadow(this.surface, this.title_label);

		# Description of the achievement
		this.description_label = this.surface.add_text("", text_x, text_y + 25 , 340, 40);
		this.description_label.char_size = 18;
		this.description_label.align = Align.TopLeft;
		this.description_label.margin = 0;

		this.description_scroller = TextScroller(this.description_label, "");
		TextShadow(this.surface, this.description_label);

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

		if ("DateEarnedHardcore" in achievement) {
			this.badge_icon_border.visible = true;
		} else {
			this.badge_icon_border.visible = false;
		}

		# Update the title and description
		this.description_scroller.set_text(unicode_fix(this.achievement.Description))
		this.title_scroller.set_text(unicode_fix(this.achievement.Title))

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

function async_load_function(rom) {
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
	subtitle = null;

	achievements = []; # Array containing all the achivements
	select_idx = 0;    # The index of the selected achivement
	offset_idx = 0;    # The index of the first visible achivement

	PAGE_SIZE = 10;    # Number of achievemnts visible on screen
	is_active = true;

	rom_loaded = "";
	rom_current = "";

	needs_reload = false;
	rom_loaded = "";
	last_romchange_time = 0;

	function constructor()
	{
		# Drawing Sufrace
		this.surface = fe.add_surface(450, 840);
		this.surface.x  = 475;
		this.surface.y  = 235;

		# Title
		local title = this.surface.add_text("Retro Achievements", 25, 10, this.surface.width-50, 50)
		title.font = "fonts/CriqueGrotesk-Bold.ttf"
		title.set_rgb(255,104,181);
		title.char_size = 32;
		title.align = Align.TopCentre;
		TextShadow(this.surface, title);

		# Subtitle
		this.subtitle = this.surface.add_text("", 25, 50, this.surface.width-50, 50);
		subtitle.font = "fonts/CriqueGrotesk.ttf"
		subtitle.set_rgb(255, 255, 255);
		subtitle.char_size = 24;
		subtitle.align = Align.TopCentre;
		TextShadow(this.surface, subtitle);

		# Message
		this.message = this.surface.add_text("", 30, 250, this.surface.width-60, 320);
		this.message.font = "fonts/CriqueGrotesk.ttf"
		this.message.char_size = 28;
		this.message.line_spacing = 1.2;
		this.message.align = Align.MiddleCentre;
		this.message.word_wrap = true;
		this.message.visible = false;

		# Create the achievement entries
		this.entries = [];
		for (local i=0; i<PAGE_SIZE; i++) {
			local entry = AchievementEntry(this.surface, 0, 105+70*i);
			this.entries.push(entry)
		}

		fe.add_ticks_callback(this, "async_load_manager");
		fe.add_transition_callback(this, "transition_callback");

		draw();
	}

	function rom_current()
	{
		return diversions.get(fe.game_info(Info.Name));
	}

	function transition_callback(ttype, var, transition_time)
	{
		# Force a achivements reload when returning from the game
		if (ttype == Transition.FromGame && this.surface.visible) {
			this.needs_reload = true;
			draw();
		}

		if (ttype == Transition.ToNewList && this.surface.visible) {
			this.needs_reload = true;
			draw();
		}

		if (ttype == Transition.ToNewSelection) {
			this.needs_reload = true;
			this.last_romchange_time = fe.layout.time;
			draw();
		}
	}

	async_load_thread = newthread(async_load_function);
	function async_load_manager(tick_time)
	{
		if (this.async_load_thread.getstatus() == "suspended") {
			local response = this.async_load_thread.wakeup();

			if (response != null) {
				if ("error" in response) {
					# Clear Achievements
					this.set_achievements([]);

					# Show Message
					this.show_message(response.error);
				}

				if ("achievements" in response) {
					# Update Achivements
					this.set_achievements(response.achievements);

					if (this.achievements.len() == 0) {
						this.show_message("RetroAchievements.org doesn't have achievements for this game.");
					}
				}
			}
		}

		if (this.rom_current() != this.rom_loaded) {
			this.needs_reload = true;
			draw();
		}

		if (this.async_load_thread.getstatus() == "idle" && this.needs_reload && this.surface.visible) {
			if (this.last_romchange_time + 300 < fe.layout.time) {
				this.async_load_thread.call(this.rom_current());
				this.needs_reload = false;
				this.rom_loaded = this.rom_current();
				draw();
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

		# Reset Indexes
		this.select_idx = 0;
		this.offset_idx = 0;

		# Redraw
		this.draw();
	}

	function draw()
	{
		# Update subtitle
		this.subtitle.msg = romlist.game_info(this.rom_current(), Info.Title);

		# If Current rom is not loaded or is still loading
		if (this.needs_reload || this.async_load_thread.getstatus() == "suspended") {
			this.show_message("Loading ...");
			return;

		# If Current rom is loaded but has not returned achievements
		} else if (this.achievements.len() == 0) {
			this.message.visible = true;
			return;

		# If Current rom is loaded and has achievements
		} else {
			this.hide_message();
		}

		# Update all the achievemnt entries
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
		if (this.is_active) return;

		# Update the instrutions bottom text
		::bottom_text.set("Move up or down to browse the Retro Achievements. Move left to play [Title] or a different game.");
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