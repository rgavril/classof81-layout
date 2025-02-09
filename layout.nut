class UserConfig {
	</ label="FB Neo Config File", help="Location of fbneo config file where the dipswitch are saved", is_input="no", order=1 />
	fbneo_config_file="/opt/retropie/configs/all/retroarch-core-options.cfg";

	</ label="Retro Achievemnts User", help="", is_input="no", order=1 />
	ra_username="";
	
	</ label="Retro Achievemnts Key", help="", is_input="no", order=1 />
	ra_apikey="";
}

::AM_CONFIG <- fe.get_config();

fe.load_module("file");
fe.load_module("animate");
fe.do_nut("utils.nut");

fe.layout.preserve_aspect_ratio=true;
fe.layout.width = 960;
fe.layout.height = 1280;
fe.layout.page_size = 6;
fe.layout.font = "fonts/CriqueGrotesk.ttf";

fe.do_nut("modules/retro-achievements.nut");
fe.do_nut("modules/romlist.nut");

fe.do_nut("modules/signal-repeater.nut");
fe.do_nut("modules/text-scroller.nut");
fe.do_nut("modules/retroarch-config.nut");
fe.do_nut("modules/fbneo-dipswitches.nut");
fe.do_nut("modules/overview.nut");
fe.do_nut("modules/rom-versions.nut");

fe.do_nut("sound-engine.nut");
fe.do_nut("bottom-text.nut");
fe.do_nut("game-button.nut");
fe.do_nut("game-buttons.nut");
fe.do_nut("right-box.nut");
fe.do_nut("right-box-overview.nut");
fe.do_nut("right-box-achievements.nut");
fe.do_nut("config-menu.nut");
fe.do_nut("config-menu-button.nut");
fe.do_nut("popup-menu.nut");
fe.do_nut("game-startup-page.nut");
fe.do_nut("splash-screen.nut");

# Background Image
fe.add_image("images/background.png", 0, 0);

# GUI Elements
splash_screen   <- SplashScreen();
sound_engine    <- SoundEngine()
signal_repeater <- SignalRepeater()
popup_menu      <- null;
bottom_text     <- BottomText();
right_box       <- RightBox();
game_buttons    <- GameButtons();
config_menu     <- ConfigMenu();
popup_menu      <- PopupMenu();
startup_page    <- GameStartupPage();

# Enable Signal Repeaters for up and down keys
signal_repeater.enable_for("down");
signal_repeater.enable_for("up");

# Key Signal Handlers
function key_detect(signal_str) {
	if ( splash_screen.key_detect(signal_str) ) { return true; }
	if ( startup_page.key_detect(signal_str)  ) { return true; }
	if ( popup_menu.key_detect(signal_str)    ) { return true; }
	if ( config_menu.key_detect(signal_str)   ) { return true; }
	if ( game_buttons.key_detect(signal_str)  ) { return true; }
	if ( right_box.key_detect(signal_str)     ) { return true; }
	# This is here only to prevent changing displays
	if (signal_str == "left" || signal_str == "right") {
		return true;
	}

	return false;
}
fe.add_signal_handler("key_detect");
