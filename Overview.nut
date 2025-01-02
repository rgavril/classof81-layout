class Overview
{
	surface = null;

	constructor()
	{
		this.surface = fe.add_surface(450, 840)
		this.surface.set_pos(475, 235)

		# Overview
		local overview = this.surface.add_text("[!OverviewFormated]", 0, 90, this.surface.width, 800);
		overview.align = Align.TopLeft;
		overview.char_size = 26;
		overview.word_wrap = true;
	}	
}