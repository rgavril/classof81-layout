return [
  {
    "name": "ACK/NACK/ENQUIRY lamps",
    "default": "Reset with CLEAR key",
    "values": [
      "Reset with CLEAR key",
      "Reset with SYN ctrl-char (^V)"
    ]
  },
  {
    "name": "Rx handshake source",
    "default": "DSR",
    "values": [
      "DSR",
      "DCD"
    ]
  },
  {
    "name": "Operating mode",
    "default": "TTY mode (no CPU)",
    "values": [
      "TTY mode (no CPU)",
      "CPU mode (CPU module required)"
    ]
  },
  {
    "name": "DTR/RTS signals",
    "default": "Permanently asserted",
    "values": [
      "Permanently asserted",
      "Affected by LINE/TRANS keys"
    ]
  },
  {
    "name": "Require RTS + CTS for ON LINE lamp",
    "default": "Off",
    "values": [
      "Off",
      "On"
    ]
  },
  {
    "name": "Automatic page-roll after end of page",
    "default": "On",
    "values": [
      "Off",
      "On"
    ]
  },
  {
    "name": "RS-232 data length",
    "default": "7 data bits",
    "values": [
      "8 data bits",
      "7 data bits"
    ]
  },
  {
    "name": "Horizontal space between chars",
    "default": "Duplicate edge of previous char",
    "values": [
      "Duplicate edge of previous char",
      "Draw gap"
    ]
  },
  {
    "name": "Automatic CR+LF after end of line",
    "default": "On",
    "values": [
      "Off",
      "On"
    ]
  },
  {
    "name": "Display mode",
    "default": "Attribute mode",
    "values": [
      "Undeline mode",
      "Attribute mode"
    ]
  },
  {
    "name": "Cursor blinking",
    "default": "Off",
    "values": [
      "Off",
      "On"
    ]
  },
  {
    "name": "Hide Attribute-changes or Underlined chars",
    "default": "On",
    "values": [
      "Off",
      "On"
    ]
  },
  {
    "name": "Unused",
    "default": "Off",
    "values": [
      "Off",
      "On"
    ]
  },
  {
    "name": "Hide ASCII control characters",
    "default": "On",
    "values": [
      "Off",
      "On"
    ]
  },
  {
    "name": "Cursor shape",
    "default": "Line",
    "values": [
      "Block",
      "Line"
    ]
  },
  {
    "name": "Automatic RTS with DTR",
    "default": "On",
    "values": [
      "Off",
      "On"
    ]
  },
  {
    "name": "Current-Loop RxD line (Unused)",
    "default": "47 Ohm series resistor",
    "values": [
      "10V zener-diode in series",
      "47 Ohm series resistor"
    ]
  }
]