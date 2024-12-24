# https://github.com/mickelson/attract/blob/master/Layouts.md
# https://github.com/Chadnaut/Attract-Mode-Modules?tab=readme-ov-file
# http://www.squirrel-lang.org/doc/sqstdlib3.pdf
# https://github.com/mickelson/attract/blob/master/config/plugins/History.dat/plugin.nut

fe.load_module("file");
fe.load_module("animate");

dofile(fe.script_dir + "utils.nut");
dofile(fe.script_dir + "GameButton.nut");
dofile(fe.script_dir + "GameButtons.nut");
dofile(fe.script_dir + "AchievementEntry.nut");
dofile(fe.script_dir + "AchievementEntries.nut");
dofile(fe.script_dir + "ConfigMenu.nut");
dofile(fe.script_dir + "ConfigMenuEntry.nut");
dofile(fe.script_dir + "SoundEngine.nut");

fe.layout.preserve_aspect_ratio=true;
fe.layout.width = 960;
fe.layout.height = 1280;
fe.layout.page_size = 6;
fe.layout.font = "CriqueGrotesk.ttf";

// fe.layout.base_rotation = RotateScreen.Right;

# Dynamic Background (To much?)
// local snap = fe.add_artwork("snap", 0, 0, 960, 1280);
// local snap_cfg = {
// 	when = Transition.ToNewSelection,
// 	property = "alpha",
// 	start = 0,
// 	end = 255,
// 	time = 500,
// 	//delay = 5000,
// }	
// animation.add( PropertyAnimation( snap, snap_cfg ) );

# Background Image
fe.add_image("images/background.png", 0, 0);

# Title Shadow
local title_shadow = fe.add_text("Retro Achievements", 470+1, 238+1, 460, 50);
title_shadow.font = "CriqueGrotesk-Bold.ttf";
title_shadow.set_rgb(0,0,0);
title_shadow.char_size = 36;
title_shadow.align = Align.TopCentre;

# Title
local title = fe.add_text("Retro Achievements", 470, 238, 460, 50);
title.font = "CriqueGrotesk-Bold.ttf";
title.set_rgb(255,104,181);
title.char_size = 36;
title.align = Align.TopCentre;

# Bottom Text
local bottom_text = fe.add_text("Press any button to start [Title]. Move up or down to select a different game. Move left to change game settings for [Title]. Move righ to access Retro Achievements.",20, 1100, 800, 160);
bottom_text.char_size = 26;
bottom_text.align = Align.BottomLeft;
bottom_text.word_wrap = true;
bottom_text.set_rgb(77, 105, 192);

# Leaderboard mockup
// for (local i=1; i<=25; i++) {
// 	local lb_text = fe.add_text(i+"\tPlayer "+i, 485, 263+(i*30), 452, 24);
// 	lb_text.align = Align.TopLeft;
// 	lb_text.char_size = 26;
// 	lb_text.set_rgb(255,255,120);
// }

local sound_engine = SoundEngine()
local game_buttons = GameButtons(20, 305)
local achivement_entries = AchievementEntries(475, 310)
local config_menu = ConfigMenu()
config_menu.hide();


function key_detect(signal_str) {
	debug();

	// sound_engine.click(); <-- This fucker gives us segfaults ?

	if (achivement_entries.is_active) {
		if ( achivement_entries.key_detect(signal_str) ) {
			return true;
		};
	}

	if (config_menu.is_active) {
		if ( config_menu.key_detect(signal_str) ) {
			return true;
		};
	}

	if (game_buttons.is_active) {
		if ( game_buttons.key_detect(signal_str) ) {
			return true;
		}
	}

	if (signal_str == "right" && game_buttons.is_active) {
		achivement_entries.activate();
		game_buttons.desactivate();
		return false;
	}

	if (signal_str == "left" && achivement_entries.is_active) {
		achivement_entries.desactivate();
		game_buttons.activate();
		return true;
	}

	if (signal_str == "left" && game_buttons.is_active) {
		game_buttons.desactivate();
		config_menu.show();
		return true;
	}

	if (signal_str == "right" && config_menu.is_active) {
		game_buttons.activate();
		config_menu.hide();
		return true;
	}
}
fe.add_signal_handler("key_detect");