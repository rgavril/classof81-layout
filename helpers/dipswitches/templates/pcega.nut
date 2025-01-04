return [
  {
    "name": "Display Type",
    "default": 9,
    "values": [
      "0000 - MDA PRIMARY, EGA COLOR, 40x25",
      "0001 - MDA PRIMARY, EGA COLOR, 80x25",
      "0010 - MDA PRIMARY, EGA HI RES EMULATE (SAME AS 0001)",
      "0011 - MDA PRIMARY, EGA HI RES ENHANCED",
      "0100 - CGA 40 PRIMARY, EGA MONOCHROME",
      "0101 - CGA 80 PRIMARY, EGA MONOCHROME",
      "0110 - MDA SECONDARY, EGA COLOR, 40x25",
      "0111 - MDA SECONDARY, EGA COLOR, 80x25",
      "1000 - MDA SECONDARY, EGA HI RES EMULATE (SAME AS 0111)",
      "1001 - MDA SECONDARY, EGA HI RES ENHANCED",
      "1010 - COLOR 40 SECONDARY, EGA",
      "1011 - COLOR 80 SECONDARY, EGA",
      "1100 - RESERVED",
      "1101 - RESERVED",
      "1110 - RESERVED",
      "1111 - RESERVED"
    ]
  },
  {
    "name": "Type of 2nd drive",
    "default": 0,
    "values": [
      "0",
      "1",
      "2",
      "3"
    ]
  },
  {
    "name": "Type of 1st drive",
    "default": 0,
    "values": [
      "0",
      "1",
      "2",
      "3"
    ]
  },
  {
    "name": "IRQ level",
    "default": 0,
    "values": [
      "5",
      "2"
    ]
  },
  {
    "name": "Install ROM?",
    "default": 0,
    "values": [
      "Yes",
      "No"
    ]
  },
  {
    "name": "Boot from floppy",
    "default": 0,
    "values": [
      "Yes",
      "No"
    ]
  },
  {
    "name": "8087 installed",
    "default": 0,
    "values": [
      "No",
      "Yes"
    ]
  },
  {
    "name": "RAM banks",
    "default": 3,
    "values": [
      "1 - 16/ 64/256K",
      "2 - 32/128/512K",
      "3 - 48/192/576K",
      "4 - 64/256/640K"
    ]
  },
  {
    "name": "Graphics adapter",
    "default": 0,
    "values": [
      "EGA/VGA",
      "Color 40x25",
      "Color 80x25",
      "Monochrome"
    ]
  },
  {
    "name": "Number of floppy drives",
    "default": 1,
    "values": [
      "1",
      "2",
      "3",
      "4"
    ]
  }
]