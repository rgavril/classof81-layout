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

fe.do_nut("modules/retroarch-config.nut");
fe.do_nut("modules/fbneo-dipswitches.nut");
fe.do_nut("modules/overview.nut");
fe.do_nut("utils.nut");
fe.do_nut("BottomText.nut");
fe.do_nut("GameButton.nut");
fe.do_nut("GameButtons.nut");
fe.do_nut("RightBox.nut");
fe.do_nut("ConfigMenu.nut");
fe.do_nut("ConfigMenuButton.nut");
fe.do_nut("PopupOptions.nut");
fe.do_nut("SoundEngine.nut");

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

popup_options <- null;
bottom_text <- BottomText();
local sound_engine = SoundEngine()
local right_box = RightBox();
local game_buttons = GameButtons();
local config_menu = ConfigMenu();
popup_options <- PopupOptions();

function key_detect(signal_str) {
	// sound_engine.click(); <-- This fucker gives us segfaults ?
	if (popup_options.is_active) {
		if (popup_options.key_detect(signal_str)) {
			return true;
		}
	}

	# If Achivements is Active
	if (right_box.is_active) {
		# Send the keypress for processing
		if ( right_box.key_detect(signal_str) ) {
			return true;
		};

		# If Right is pressed, activate Game Buttons
		if (signal_str == "left") {
			game_buttons.activate();
			right_box.desactivate();
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
			right_box.activate();
			game_buttons.desactivate();
			return false;
		}
	}

	# print("SIGNAL : " + signal_str + "\n"); return true;
	return false;
}
fe.add_signal_handler("key_detect");