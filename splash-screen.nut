class SplashScreen
{
	is_active = false;
	is_hidden = false;
	video = null;
	
	constructor()
	{
		is_active = true;

		this.video = fe.add_image("videos/splash.mp4", 0, 0, 960, 1280);
		this.video.zorder = 100;
		this.video.video_playing = true;
		this.video.video_flags = Vid.NoLoop;

		fe.add_transition_callback(this, "transition_callback");
		fe.add_ticks_callback(this, "on_tick");
	}

	function key_detect(signal_str) {
		if (!this.is_active) {
			return false;
		}

		if (!this.is_hidden) {
			this.hide();
			return true;
		}
	}

	function on_tick(tick_time) {
		if (!this.is_active) 
			return;

		// if (this.video.video_time >= this.video.video_duration) { # This doesn't work
		if (tick_time >= this.video.video_duration) {
			this.stop();
			this.hide();
		}
	}

	function transition_callback(ttype, var, transition_time)
	{
		if (ttype == Transition.StartLayout && var == FromTo.Frontend) {
			this.start();
		}
	}

	function start()
	{
		this.video.file_name = "videos/splash.mp4"
		this.is_active = true;
		this.video.video_playing = true;
	}

	function stop()
	{
		this.is_active = false;
		this.video.video_playing = false;
		this.video.file_name = "";
	}

	function hide()
	{
		this.is_hidden = true;
		// animation.add(PropertyAnimation(this.video, {property = "width", end=0, time = 200, tween = Tween.Linear}));
		// animation.add(PropertyAnimation(this.video, {property = "origin_x", end=-960/2, time = 200, tween = Tween.Linear}));
		// animation.add(PropertyAnimation(this.video, {property = "height", end=0, time = 200, tween = Tween.Linear}));
		// animation.add(PropertyAnimation(this.video, {property = "origin_y", end=-1280/2, time = 200, tween = Tween.Linear}));
		// animation.add(PropertyAnimation(this.video, {property = "y", end=-1300, time = 700, tween = Tween.Expo}));
		animation.add(PropertyAnimation(this.video, {property = "x", end=-1960, time = 1000, tween = Tween.Quart}));
		// this.video.visible = false;
	}
}