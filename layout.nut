class UserConfig {
	</ label="FB Neo Config File", help="Location of fbneo config file where the dipswitch are saved", is_input="no", order=1 />
	fbneo_config_file="/opt/retropie/configs/all/retroarch-core-options.cfg";
}
::AM_CONFIG <- fe.get_config();

fe.layout.preserve_aspect_ratio=true;
fe.layout.width = 960;
fe.layout.height = 1280;
fe.layout.page_size = 6;
fe.layout.font = "fonts/CriqueGrotesk.ttf";

fe.load_module("file");
fe.load_module("animate");

fe.do_nut("modules/signal-repeater.nut");
fe.do_nut("modules/retroarch-config.nut");
fe.do_nut("modules/fbneo-dipswitches.nut");
fe.do_nut("modules/overview.nut");
fe.do_nut("utils.nut");
fe.do_nut("sound-engine.nut");
fe.do_nut("bottom-text.nut");
fe.do_nut("game-button.nut");
fe.do_nut("game-buttons.nut");
fe.do_nut("right-box.nut");
fe.do_nut("config-menu.nut");
fe.do_nut("config-menu-button.nut");
fe.do_nut("popup-menu.nut");
fe.do_nut("game-startup-page.nut");
fe.do_nut("splash-screen.nut");

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
splash_screen   <- SplashScreen();
sound_engine    <- SoundEngine()
signal_repeater <- SignalRepeater()
popup_menu      <- null;
bottom_text     <- BottomText();
right_box       <- RightBox();
game_buttons    <- GameButtons();
config_menu     <- ConfigMenu();
popup_menu      <- PopupMenu();
starup_page     <- GameStartupPage();

signal_repeater.enable_for("down");
signal_repeater.enable_for("up");

function key_detect(signal_str) {
	if (splash_screen.is_active) {
		if (splash_screen.key_detect(signal_str)) {
			return true;
		}

		return false;
	}

	if (starup_page.is_active) {
		if (starup_page.key_detect(signal_str)) {
			return true;
		}
		
		return false;
	}

	if (popup_menu.is_active) {
		if (popup_menu.key_detect(signal_str)) {
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

		if (signal_str == "select" && !game_buttons.is_config_mode) {
			starup_page.show();
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