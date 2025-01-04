return [
  {
    "name": "Baud Rate",
    "default": 11,
    "values": [
      "110",
      "150",
      "300",
      "600",
      "1200",
      "1800",
      "2000",
      "2400",
      "3600",
      "4800",
      "7200",
      "9600",
      "19200",
      "38400"
    ]
  },
  {
    "name": "8 bit mode",
    "default": 0,
    "values": [
      "Mode A/0 - 8th bit ignored, sent as 0",
      "Mode B/1 - 8th bit ignored, sent as 1",
      "Mode C/2 - 8 bit escape mode",
      "Mode D/3 - 8 bit escape mode, invert 8th bit",
      "Mode E/4 - 8 bit data mode",
      "Mode F/5 - 8 bit data mode, invert 8th bit",
      "7 bit data with odd parity, 8th bit ignored on input",
      "7 bit data with even parity, 8th bit ignored on input"
    ]
  },
  {
    "name": "Duplex",
    "default": 1,
    "values": [
      "Half",
      "Full"
    ]
  },
  {
    "name": "Cursor",
    "default": 0,
    "values": [
      "Underline",
      "Block"
    ]
  },
  {
    "name": "Transmit mode",
    "default": 0,
    "values": [
      "Normal",
      "Slow"
    ]
  },
  {
    "name": "Wrap at EOL",
    "default": 0,
    "values": [
      "No",
      "Yes"
    ]
  },
  {
    "name": "Auto LF on CR",
    "default": 0,
    "values": [
      "No",
      "Yes"
    ]
  },
  {
    "name": "Auto CR on LF",
    "default": 0,
    "values": [
      "No",
      "Yes"
    ]
  },
  {
    "name": "Mode",
    "default": 0,
    "values": [
      "Heath/VT52",
      "ANSI"
    ]
  },
  {
    "name": "Keypad Shifted",
    "default": 0,
    "values": [
      "No",
      "Yes"
    ]
  },
  {
    "name": "DEC Keypad Codes",
    "default": 0,
    "values": [
      "Off",
      "On"
    ]
  }
]