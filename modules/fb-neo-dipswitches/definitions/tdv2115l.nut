return [
  {
    "name": "ACK/NACK/ENQUIRY lamps",
    "default": 0,
    "values": [
      "Reset with CLEAR key",
      "Reset with SYN ctrl-char (^V)"
    ]
  },
  {
    "name": "Rx handshake source",
    "default": 0,
    "values": [
      "DSR",
      "DCD"
    ]
  },
  {
    "name": "Operating mode",
    "default": 0,
    "values": [
      "TTY mode (no CPU)",
      "CPU mode (CPU module required)"
    ]
  },
  {
    "name": "DTR/RTS signals",
    "default": 0,
    "values": [
      "Permanently asserted",
      "Affected by LINE/TRANS keys"
    ]
  },
  {
    "name": "Require RTS + CTS for ON LINE lamp",
    "default": 0,
    "values": [
      "Off",
      "On"
    ]
  },
  {
    "name": "Automatic page-roll after end of page",
    "default": 1,
    "values": [
      "Off",
      "On"
    ]
  },
  {
    "name": "RS-232 data length",
    "default": 1,
    "values": [
      "8 data bits",
      "7 data bits"
    ]
  },
  {
    "name": "Horizontal space between chars",
    "default": 0,
    "values": [
      "Duplicate edge of previous char",
      "Draw gap"
    ]
  },
  {
    "name": "Automatic CR+LF after end of line",
    "default": 1,
    "values": [
      "Off",
      "On"
    ]
  },
  {
    "name": "Display mode",
    "default": 1,
    "values": [
      "Undeline mode",
      "Attribute mode"
    ]
  },
  {
    "name": "Cursor blinking",
    "default": 0,
    "values": [
      "Off",
      "On"
    ]
  },
  {
    "name": "Hide Attribute-changes or Underlined chars",
    "default": 1,
    "values": [
      "Off",
      "On"
    ]
  },
  {
    "name": "Unused",
    "default": 0,
    "values": [
      "Off",
      "On"
    ]
  },
  {
    "name": "Hide ASCII control characters",
    "default": 1,
    "values": [
      "Off",
      "On"
    ]
  },
  {
    "name": "Cursor shape",
    "default": 1,
    "values": [
      "Block",
      "Line"
    ]
  },
  {
    "name": "Automatic RTS with DTR",
    "default": 1,
    "values": [
      "Off",
      "On"
    ]
  },
  {
    "name": "Current-Loop RxD line (Unused)",
    "default": 1,
    "values": [
      "10V zener-diode in series",
      "47 Ohm series resistor"
    ]
  }
]