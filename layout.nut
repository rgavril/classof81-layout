# https://github.com/mickelson/attract/blob/master/Layouts.md
# https://github.com/Chadnaut/Attract-Mode-Modules?tab=readme-ov-file
# http://www.squirrel-lang.org/doc/sqstdlib3.pdf
# https://github.com/mickelson/attract/blob/master/config/plugins/History.dat/plugin.nut

dofile(fe.script_dir + "GameButton.nut");
dofile(fe.script_dir + "GameButtons.nut");
dofile(fe.script_dir + "AchivementEntry.nut");

fe.layout.preserve_aspect_ratio=true;
fe.layout.width = 960;
fe.layout.height = 1280;
fe.layout.page_size = 6;
// fe.layout.base_rotation = RotateScreen.Right;

# Background Image
fe.add_image("images/background.png", 0, 0);

local click_sounds = [];
local click_sounds_index = 0;
click_sounds.push(fe.add_sound("sounds/click.mp3", false))
click_sounds.push(fe.add_sound("sounds/click.mp3", false))
click_sounds.push(fe.add_sound("sounds/click.mp3", false))
click_sounds.push(fe.add_sound("sounds/click.mp3", false))
click_sounds.push(fe.add_sound("sounds/click.mp3", false))

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

// local snap_surface = fe.add_surface(960,1280);
// snap_surface.x = 0
// snap_surface.y = 0
// local snap = ::fe.add_artwork("snap", 0, 0);
// snap.preserve_aspect_ratio = true;
// snap.width = 1200;
// snap.zorder = -1;

# Bottom Text
local bottom_text = fe.add_text("Press any button to start [Title]. Move up or down to select a different game.",0, 1200, 960, 200);
bottom_text.font = "Roboto-Regular";
bottom_text.char_size = 26;
bottom_text.align = Align.TopLeft;
bottom_text.word_wrap = true;
bottom_text.set_rgb(144, 172, 191);

# Initialize the list of button
local game_buttons = GameButtons(13, 305)

function runTransitions(ttype, var, transition_time)
{
	if (ttype == Transition.FromOldSelection) {
		click_sounds[click_sounds_index].playing = true;
		click_sounds_index++;
		if (click_sounds_index >= 4 ) {
			click_sounds_index = 0;
		}
		game_buttons.refresh()
	}

	if (ttype == Transition.StartLayout) {
		game_buttons.refresh()
	}
}
fe.add_transition_callback("runTransitions");

local ra = dofile(fe.script_dir + "/ra2nut/achivements.nut");

# Sort achivements by keys
local keys = [];
foreach (key, value in ra.Achievements) {
    keys.push(key);
}
keys.sort();

foreach (i,key in keys) {
	AchivementEntry(490, 380+85*(i++), ra.Achievements[key]);
	if (i == 8) break
}