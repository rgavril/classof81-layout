# https://github.com/mickelson/attract/blob/master/Layouts.md
# https://github.com/Chadnaut/Attract-Mode-Modules?tab=readme-ov-file
# http://www.squirrel-lang.org/doc/sqstdlib3.pdf
# https://github.com/mickelson/attract/blob/master/config/plugins/History.dat/plugin.nut

fe.load_module("file");

dofile(fe.script_dir + "utils.nut");
dofile(fe.script_dir + "GameButton.nut");
dofile(fe.script_dir + "GameButtons.nut");
dofile(fe.script_dir + "AchievementEntry.nut");
dofile(fe.script_dir + "AchievementEntries.nut");
dofile(fe.script_dir + "SoundEngine.nut");

fe.layout.preserve_aspect_ratio=true;
fe.layout.width = 960;
fe.layout.height = 1280;
fe.layout.page_size = 6;
fe.layout.font = "CriqueGrotesk.ttf";

// fe.layout.base_rotation = RotateScreen.Right;

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

# Sidebox Border
local sidebox_border = fe.add_image("images/sidebox_active.png", 460, 220);
sidebox_border.visible = false;

# Leaderboard mockup
// for (local i=1; i<=25; i++) {
// 	local lb_text = fe.add_text(i+"\tPlayer "+i, 485, 263+(i*30), 452, 24);
// 	lb_text.align = Align.TopLeft;
// 	lb_text.char_size = 26;
// 	lb_text.set_rgb(255,255,120);
// }


local game_buttons = GameButtons(20, 305)
local sound_engine = SoundEngine()
local ra_entries = AchievementEntries(475, 310)

function runTransitions(ttype, var, transition_time)
{
	if (ttype == Transition.FromOldSelection) {
		sound_engine.click()
		game_buttons.refresh()
		ra_entries.load()
	}

	if (ttype == Transition.StartLayout) {
		game_buttons.refresh()
		ra_entries.load();
	}
}
fe.add_transition_callback("runTransitions");

function key_detect(signal_str) {
	if (signal_str == "right") {
		ra_entries.activate();
		sidebox_border.visible = true;
		return true;
	}

	if (signal_str == "left") {
		ra_entries.desactivate();
		sidebox_border.visible = false;
		return true;
	}
}
fe.add_signal_handler("key_detect");