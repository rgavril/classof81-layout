# https://github.com/mickelson/attract/blob/master/Layouts.md
# https://github.com/Chadnaut/Attract-Mode-Modules?tab=readme-ov-file
# http://www.squirrel-lang.org/doc/sqstdlib3.pdf
# https://github.com/mickelson/attract/blob/master/config/plugins/History.dat/plugin.nut

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

class GameButton {
	m_x = 0;
	m_y = 0;
	m_surface = null;
	m_background = null;
	m_selection_box = null;
	m_logo = null;
	m_logo_shadow = null;
	m_desaturize_shader = null;
	m_shadow_shader = null;
	m_icon = null;
	m_pointer = null;

	constructor(x=0, y=0)
	{
		# Set Coordonates
		m_x = x; m_y = y;

		# Create surface for drawing onto and position it
		m_surface = fe.add_surface(500, 300);
		m_surface.set_pos(m_x, m_y);
		m_surface.origin_y = m_surface.texture_height/2;

		# Draw the button background image on the surface
		m_background = m_surface.add_image("images/button_background.png");
		m_background.y = m_surface.texture_height / 2;

		# Pointer
		m_pointer = m_surface.add_image("images/pointer.png", 0, 0);
		m_pointer.origin_x = m_pointer.texture_width;
		m_pointer.origin_y = m_pointer.texture_height / 2;
		m_pointer.x = 443;
		m_pointer.y = m_background.y + m_background.texture_height / 2;
		m_pointer.zorder = -1;

		# Create the the selection rectangle
		m_selection_box = m_surface.add_image("images/button_selection.png",0,0);
		m_selection_box.y = m_surface.texture_height / 2;
		m_selection_box.origin_x = m_selection_box.texture_width;
		m_selection_box.x = m_background.texture_width + m_background.x;

		# Game Logo
		m_logo_shadow = m_surface.add_image(null);
		m_logo = m_surface.add_image(null);

		# Gear Icon
		m_icon = m_surface.add_image("images/gear.png", 0, 0, 90, 90);
		m_icon.origin_y = 30;
		m_icon.origin_x = 30;
		m_icon.y = m_background.y;
		m_icon.x = 43;

		# Shader used to desaturade the unselected logo on buttons
		m_desaturize_shader = fe.add_shader(Shader.Fragment, "shaders/desaturate.glsl");
		m_shadow_shader = fe.add_shader(Shader.Fragment, "shaders/shadow.glsl");

		# Draw it deselected
		deselect();
	}

	function setLogo(filename)
	{	
		m_logo.swap(m_surface.add_image(filename,-1000, -1000))

		# Resize the logo
		m_logo.preserve_aspect_ratio = true;
		m_logo.mipmap = true;
		m_logo.width = 260;

		# Set the origin point to the center-right of the logo
		m_logo.origin_y = (m_logo.texture_height * (m_logo.width / m_logo.texture_width)) / 2;
		m_logo.origin_x = m_logo.width;

		# Align it horizontaly near the end of the button background
		m_logo.x = m_background.x + m_background.texture_width - 15;
		# Align it verticaly to the middle of the button background image
		m_logo.y = m_background.y + m_background.texture_height/2;


		m_logo_shadow.swap(m_surface.add_image(filename,-1000, -1000))
		m_logo_shadow.preserve_aspect_ratio = true;
		m_logo_shadow.width = m_logo.width;
		m_logo_shadow.origin_y = m_logo.origin_y - 2;
		m_logo_shadow.origin_x = m_logo.origin_x - 2;
		m_logo_shadow.x = m_logo.x;
		m_logo_shadow.y = m_logo.y;
		m_logo_shadow.shader = m_shadow_shader;
	}

	function select()
	{
		# Remove Desaturate Shader
		m_logo.shader = fe.add_shader(Shader.Empty)
		m_logo.alpha = 255;

		# Show Pointer
		m_pointer.alpha = 255;

		# Show selection rectangle
		m_selection_box.alpha = 255;

		m_logo_shadow.alpha = 200;
	}

	function deselect()
	{
		# Desaturize
		m_logo.shader = m_desaturize_shader;

		# Hide Pointer
		m_pointer.alpha = 0;

		# Hide selection rectangel
		m_selection_box.alpha = 0;

		m_logo_shadow.alpha = 100;
	}

	function hide()
	{
		m_surface.alpha = 0;
	}

	function show()
	{
		m_surface.alpha = 255;
	}
}

# Initialize the list of button
local buttons = [];
for (local i=0; i<6; i++) {
	local button = GameButton(13, 305+135*i);
	buttons.push(button);
}

function drawPage() {
	# Calculate the page number
	local page_number = fe.list.index / 6

	foreach(index,button in buttons) {
		# Calculate the index relative to current selected game
		local relative_index = page_number * 6 + (index - fe.list.index)
		# Caclulate the index relative to the entire gamelist
		local absolute_index = page_number * 6 + index

		# Load the logo
		button.setLogo(fe.get_art("wheel", relative_index))
		button.deselect()
		button.show()

		# If the button is pointing to a game ouside the list of games, hide it
		if (absolute_index >= fe.list.size) {
			button.hide();
		}

		# Select the current button
		if (relative_index == 0){
			button.select();
		}
	}
}

function runTransitions(ttype, var, transition_time)
{
	if (ttype == Transition.FromOldSelection) {
		click_sounds[click_sounds_index].playing = true;
		click_sounds_index++;
		if (click_sounds_index >= 4 ) {
			click_sounds_index = 0;
		}
		drawPage();
	}

	if (ttype == Transition.StartLayout) {
		drawPage();
	}
}
fe.add_transition_callback("runTransitions");

class AchivementEntry {
	m_x = 0
	m_y = 0
	m_info = null

	m_badge = null;
	m_surface = null;
	m_title = null;
	m_description = null;

	constructor(x, y, info) {
		m_info = info;
		m_x = x;
		m_y = y;

		m_surface = fe.add_surface(460, 350);
		m_surface.set_pos(m_x, m_y);

		m_badge = m_surface.add_image("images/achivements/"+info.BadgeName+".png", 0, 0);
		m_badge.shader = fe.add_shader(Shader.Fragment, "shaders/desaturate.glsl");
		// m_badge.alpha = 100;

		m_title = m_surface.add_text(info.Title, 65-3, 0-14, 365, 32);
		m_title.char_size = 22;
		m_title.align = Align.TopLeft;
		m_title.word_wrap = true;
		m_title.style = Style.Bold;
		m_title.set_rgb(255,252,103);

		m_description = m_surface.add_text(info.Description, 65, 22-7, 365, 100);
		m_description.char_size = 20;
		m_description.align = Align.TopLeft;
		m_description.word_wrap = true;
		m_description.line_spacing = 0.75;
	}
}

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