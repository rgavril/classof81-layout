class UserConfig {
	</ label="FB Neo Config File", help="Location of fbneo config file where the dipswitch are saved", is_input="no", order=1 />
	fbneo_config_file="/opt/retropie/configs/all/retroarch-core-options.cfg";
}
::AM_CONFIG <- fe.get_config();

fe.layout.preserve_aspect_ratio=true;
fe.layout.width = 960;
fe.layout.height = 1280;
fe.layout.page_size = 6;
fe.layout.font = "CriqueGrotesk.ttf";

fe.load_module("file");
fe.load_module("animate");

dofile(fe.script_dir + "/modules/retroarch-config.nut");
dofile(fe.script_dir + "/modules/fbneo-dipswitches.nut");
dofile(fe.script_dir + "utils.nut");
dofile(fe.script_dir + "BottomText.nut");
dofile(fe.script_dir + "GameButton.nut");
dofile(fe.script_dir + "GameButtons.nut");
dofile(fe.script_dir + "AchievementEntry.nut");
dofile(fe.script_dir + "AchievementEntries.nut");
dofile(fe.script_dir + "ConfigMenu.nut");
dofile(fe.script_dir + "ConfigMenuButton.nut");
dofile(fe.script_dir + "SoundEngine.nut");

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

bottom_text <- BottomText();
local sound_engine = SoundEngine()
local game_buttons = GameButtons();
local achivement_entries = AchievementEntries();
local config_menu = ConfigMenu();

function test_design() {
	// local marquee = fe.add_artwork("flyer", 480+50, 540);
	// marquee.width = 440-100;
	// // marquee.height = 177;
	// marquee.preserve_aspect_ratio = true;

	// local snap = fe.add_artwork("snap", 480+15, 240+120);
	// snap.width = 440-30;
	// snap.height = snap.width*4/3;
	// snap.height = 830-177;
	// snap.shader = fe.add_shader(Shader.Fragment, "shaders/desaturate.glsl");
	// snap.alpha = 100;
	// snap.preserve_aspect_ratio = true;

	// local snap2 = fe.add_artwork("snap", 480+15, 240+120);
	// snap2.width = 440-30;
	// snap2.height = snap2.width*4/3;
	// snap2.alpha = 50;
	// snap2.shader = fe.add_shader(Shader.Fragment, "shaders/desaturate.glsl");

	local lines = [
		// {"title": "Title", "value": "[Title]"},
		// {"title": "Year", "value": "[Year] [Manufacturer]"},
		// {"title": "By", "value": "[Manufacturer]"},
		// {"title": "PlayedTime", "value": "[PlayedTime]"},
		// {"title": "PlayedCount", "value": "[PlayedCount]"},
		// {"title": "ListEntry", "value": "[ListEntry] / [ListSize]"},
	];
	foreach (i,line in lines) {
		local title = fe.add_text(line["value"], 480, 290+35*i, 440, 42);
		title.set_rgb(255,252,103);
		title.char_size = 28;
		title.align = Align.TopCentre;

		// local padding = 100;
		// local value = fe.add_text(line["value"], 480+padding, 350+35*i, 440-padding, 42);
		// value.set_rgb(255,255,255);
		// value.char_size = 28;
		// value.align = Align.TopRight;
	}
}
test_design();

function key_detect(signal_str) {
	// sound_engine.click(); <-- This fucker gives us segfaults ?

	# If Achivements is Active
	if (achivement_entries.is_active) {
		# Send the keypress for processing
		if ( achivement_entries.key_detect(signal_str) ) {
			return true;
		};

		# If Right is pressed, activate Game Buttons
		if (signal_str == "left") {
			game_buttons.activate();
			achivement_entries.desactivate();
			return true;
		}
	}

	# Config Menu is active
	if (config_menu.is_active) {
		# Send the keypress for processing
		if ( config_menu.key_detect(signal_str) ) {
			return true;
		};

		# If back is pressed, activate Game Buttons
		if (signal_str == "back") {
			game_buttons.activate();
			config_menu.hide();
			return true;
		}
	}

	# Game Buttons are active
	if (game_buttons.is_active) {
		# Send the keypress for processing
		if ( game_buttons.key_detect(signal_str) ) {
			return true;
		}

		# If Game Buttons is pointing to config gear 
		# and select is pressed activate Config Menu
		if (signal_str == "select" && game_buttons.is_config_mode) {
			config_menu.show();
			// game_buttons.desactivate();
			return true;
		}

		# If Right is pressed, activate Achivements
		if (signal_str == "right") {
			achivement_entries.activate();
			game_buttons.desactivate();
			return false;
		}
	}

	# print("SIGNAL : " + signal_str + "\n"); return true;
	return false;
}
fe.add_signal_handler("key_detect");