# https://github.com/mickelson/attract/blob/master/Layouts.md
# https://github.com/Chadnaut/Attract-Mode-Modules?tab=readme-ov-file
# http://www.squirrel-lang.org/doc/sqstdlib3.pdf
# https://github.com/mickelson/attract/blob/master/config/plugins/History.dat/plugin.nut

dofile(fe.script_dir + "GameButton.nut");
dofile(fe.script_dir + "GameButtons.nut");
dofile(fe.script_dir + "AchievementEntry.nut");
dofile(fe.script_dir + "AchievementEntries.nut");
dofile(fe.script_dir + "SoundEngine.nut");

fe.layout.preserve_aspect_ratio=true;
fe.layout.width = 960;
fe.layout.height = 1280;
fe.layout.page_size = 6;
// fe.layout.base_rotation = RotateScreen.Right;

# Background Image
fe.add_image("images/background.png", 0, 0);

# Games Text List
// local gameList = fe.add_listbox(490,300,421,700);
// gameList.charsize = 30;
// gameList.rows=16;
// gameList.align=Align.Left;

# Title 
local title = fe.add_text("[Title]", 470, 245, 460, 50);
title.font = "Roboto-Bold";
title.set_rgb(238,95,167);
title.char_size = 36;
title.align = Align.TopCentre;
title.word_wrap = true;
//title.word_wrap = true;

# Subtitle
local subtitle = fe.add_text("[Year] [Manufacturer]", 470, 290, 460, 200);
subtitle.char_size = 24;
subtitle.align = Align.TopCentre;

local snap_surface = fe.add_surface(960,1280);
snap_surface.x = 0
snap_surface.y = 0
snap_surface.zorder = -1;
local snap = snap_surface.add_artwork("snap", 0, 0);
snap.preserve_aspect_ratio = true;
snap.width = 1200;

# Bottom Text
local bottom_text = fe.add_text("Press any button to start [Title]. Move up or down to select a different game.",0, 1200, 960, 200);
bottom_text.font = "Roboto-Regular";
bottom_text.char_size = 26;
bottom_text.align = Align.TopLeft;
bottom_text.word_wrap = true;
bottom_text.set_rgb(144, 172, 191);


local game_buttons = GameButtons(13, 305)
local sound_engine = SoundEngine()
local achievement_entries = AchievementEntries()

function runTransitions(ttype, var, transition_time)
{
	if (ttype == Transition.FromOldSelection) {
		sound_engine.click()
		game_buttons.refresh()
	}

	if (ttype == Transition.StartLayout) {
		game_buttons.refresh()
	}
}
fe.add_transition_callback("runTransitions");