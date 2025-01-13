class SignalRepeater
{
	valid_signals = ["up", "down", "left", "right"];
	enabled_for = {};
	last_repeat_time = {};
	hold_time = {};

	constructor()
	{
		# Initialize
		foreach (signal_str in this.valid_signals) {
			this.enabled_for[signal_str] <- false;
			this.last_repeat_time[signal_str] <- 0;
			this.hold_time[signal_str] <- 0;
		}

		# Add a tick call back to resend the signals
		fe.add_ticks_callback(this, "ticks_callback");
	}

	function ticks_callback(tick_time)
	{
		foreach (signal_str in this.valid_signals) {
			# If the repeater is not enable for this signal move to the next
			if (! this.enabled_for[signal_str]) {
				continue;
			}

			# If key is being hold
			if (fe.get_input_state(signal_str)) {

				# If it was never repeated since it was hold
				if (this.last_repeat_time[signal_str] == 0) {
					
					# Mark it as started, but also add a 500ms delay
					this.last_repeat_time[signal_str] = tick_time + 500;
				}

				# If the signal was repeated more that 100ms ago 
				if (tick_time - this.last_repeat_time[signal_str] > 100) {
					# Update hold time
					this.hold_time[signal_str] += (tick_time - this.last_repeat_time[signal_str]);

					# Send a repeat signal
					fe.signal(signal_str);

					# Modify the last repeat time
					this.last_repeat_time[signal_str] = tick_time;
				}

			# If the key is no not being hold
			} else {
				this.last_repeat_time[signal_str] = 0;
				this.hold_time[signal_str] = 0;
			}
		}
	}

	function enable_for(signal_str)
	{
		this.enabled_for[signal_str] = true;
		this.last_repeat_time[signal_str] = 0;
	}

	function disable_for(signal_str)
	{
		this.enabled_for[signal_str] = false;;
	}
}