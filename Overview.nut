class Overview
{
	surface = null;

	constructor()
	{
		this.surface = fe.add_surface(450, 840)
		this.surface.set_pos(475, 235)

		# Title Shadow
		local title_shadow = this.surface.add_text("[!TitleFormated]", 0+1, 0+1, this.surface.width, 50)
		title_shadow.font = "CriqueGrotesk-Bold.ttf"
		title_shadow.set_rgb(0,0,0)
		title_shadow.char_size = 36
		title_shadow.align = Align.TopCentre

		# Title
		local title = this.surface.add_text("[!TitleFormated]", 0, 0, this.surface.width, 50)
		title.font = "CriqueGrotesk-Bold.ttf";
		title.set_rgb(255,104,181);
		title.char_size = 36;
		title.align = Align.TopCentre;

		# Subtitle
		local subtitle = this.surface.add_text("[Year] [Manufacturer]", 0, 50, this.surface.width, 50);
		// subtitle.font = "CriqueGrotesk-Bold.ttf";
		subtitle.set_rgb(255,252,103);
		subtitle.char_size = 26;
		subtitle.align = Align.TopCentre;

		# Overview
		local overview = this.surface.add_text("[!OverviewFormated]", 0, 90, this.surface.width, 800);
		overview.align = Align.TopLeft;
		overview.char_size = 26;
		overview.word_wrap = true;
	}	
}