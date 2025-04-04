return [
  {
    "name": "Operation Mode",
    "default": 0,
    "values": [
      "Monitor",
      "Diagnostic"
    ]
  },
  {
    "name": "S-100 MWRITE",
    "default": 1,
    "values": [
      "Disabled",
      "Enabled"
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
    "name": "Power Up",
    "default": 1,
    "values": [
      "Boot Address",
      "Monitor"
    ]
  },
  {
    "name": "Power-On-Jump Address",
    "default": 0,
    "values": [
      "F800H",
      "F000H",
      "E800H",
      "E000H",
      "D800H",
      "D000H",
      "C800H",
      "C000H",
      "B800H",
      "B000H",
      "A800H",
      "A000H",
      "9800H",
      "9000H",
      "8800H",
      "8000H",
      "7800H",
      "7000H",
      "6800H",
      "6000H",
      "5800H",
      "5000H",
      "4800H",
      "4000H",
      "3800H",
      "3000H",
      "2800H",
      "2000H",
      "1800H",
      "Boot DJ/DMA",
      "Boot HD/DMA",
      "Boot HDCA"
    ]
  },
  {
    "name": "Diagnostics",
    "default": 0,
    "values": [
      "Read Registers",
      "Write Registers",
      "Write Map RAMs",
      "Write R/W RAMs",
      "R/W FPP",
      "R/W S-100 Bus (High/Low)",
      "R/W S-100 Bus (Alternating)",
      "Read Switches"
    ]
  },
  {
    "name": "Bank Select Data Bit 0B",
    "default": 0,
    "values": [
      "0",
      "1"
    ]
  },
  {
    "name": "Bank Select Data Bit 1B",
    "default": 0,
    "values": [
      "0",
      "1"
    ]
  },
  {
    "name": "Bank Select Data Bit 2B",
    "default": 0,
    "values": [
      "0",
      "1"
    ]
  },
  {
    "name": "Bank Select Data Bit 3B",
    "default": 0,
    "values": [
      "0",
      "1"
    ]
  },
  {
    "name": "Bank Select Data Bit 4B",
    "default": 0,
    "values": [
      "0",
      "1"
    ]
  },
  {
    "name": "Bank Select Data Bit 5B",
    "default": 0,
    "values": [
      "0",
      "1"
    ]
  },
  {
    "name": "Bank Select Data Bit 6B",
    "default": 0,
    "values": [
      "0",
      "1"
    ]
  },
  {
    "name": "Bank Select Data Bit 7B",
    "default": 0,
    "values": [
      "0",
      "1"
    ]
  },
  {
    "name": "Bank Select Port",
    "default": 1,
    "values": [
      "00H",
      "40H",
      "FFH"
    ]
  },
  {
    "name": "Extended Addressing",
    "default": 0,
    "values": [
      "000000H",
      "FF0000H"
    ]
  },
  {
    "name": "First 16K Memory Addressing",
    "default": 0,
    "values": [
      "Block 0 (0000H-3FFFH)",
      "Block 1 (4000H-7FFFH)",
      "Block 2 (8000H-BFFFH)",
      "Block 3 (C000H-FFFFH"
    ]
  },
  {
    "name": "Second 16K Memory Addressing",
    "default": 1,
    "values": [
      "Block 0 (0000H-3FFFH)",
      "Block 1 (4000H-7FFFH)",
      "Block 2 (8000H-BFFFH)",
      "Block 3 (C000H-FFFFH"
    ]
  },
  {
    "name": "Third 16K Memory Addressing",
    "default": 2,
    "values": [
      "Block 0 (0000H-3FFFH)",
      "Block 1 (4000H-7FFFH)",
      "Block 2 (8000H-BFFFH)",
      "Block 3 (C000H-FFFFH"
    ]
  },
  {
    "name": "Fourth 16K Memory Addressing",
    "default": 3,
    "values": [
      "Block 0 (0000H-3FFFH)",
      "Block 1 (4000H-7FFFH)",
      "Block 2 (8000H-BFFFH)",
      "Block 3 (C000H-FFFFH"
    ]
  },
  {
    "name": "Bank Select Data Bit A0",
    "default": 1,
    "values": [
      "0",
      "1"
    ]
  },
  {
    "name": "Bank Select Data Bit A1",
    "default": 0,
    "values": [
      "0",
      "1"
    ]
  },
  {
    "name": "Bank Select Data Bit A2",
    "default": 0,
    "values": [
      "0",
      "1"
    ]
  },
  {
    "name": "Bank Select Data Bit A3",
    "default": 0,
    "values": [
      "0",
      "1"
    ]
  },
  {
    "name": "Bank Select Data Bit A4",
    "default": 0,
    "values": [
      "0",
      "1"
    ]
  },
  {
    "name": "Bank Select Data Bit A5",
    "default": 0,
    "values": [
      "0",
      "1"
    ]
  },
  {
    "name": "Bank Select Data Bit A6",
    "default": 0,
    "values": [
      "0",
      "1"
    ]
  },
  {
    "name": "Bank Select Data Bit A7",
    "default": 0,
    "values": [
      "0",
      "1"
    ]
  },
  {
    "name": "Bank B Recognizes Phantom",
    "default": 1,
    "values": [
      "Off",
      "On"
    ]
  },
  {
    "name": "Bank A Recognizes Phantom",
    "default": 1,
    "values": [
      "Off",
      "On"
    ]
  },
  {
    "name": "Addressing Mode",
    "default": 0,
    "values": [
      "Extended Addressing",
      "Bank Select"
    ]
  },
  {
    "name": "Bank A Lower 32K",
    "default": 1,
    "values": [
      "Disabled",
      "Enabled"
    ]
  },
  {
    "name": "Bank A Upper 32K",
    "default": 1,
    "values": [
      "Disabled",
      "Enabled"
    ]
  },
  {
    "name": "Bank B Lower 32K",
    "default": 1,
    "values": [
      "Disabled",
      "Enabled"
    ]
  },
  {
    "name": "Bank B Upper 32K",
    "default": 1,
    "values": [
      "Disabled",
      "Enabled"
    ]
  },
  {
    "name": "2K Segment Disable",
    "default": 1,
    "values": [
      "Off",
      "Page 0",
      "Page 1",
      "Page 2",
      "Page 3",
      "Page 4",
      "Page 5",
      "Page 6",
      "Page 7"
    ]
  },
  {
    "name": "Baud Rate",
    "default": 0,
    "values": [
      "Automatic",
      "19200",
      "9600",
      "4800",
      "2400",
      "1200",
      "300",
      "110"
    ]
  },
  {
    "name": "Unused",
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
    "name": "Unused",
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
    "name": "Unused",
    "default": 0,
    "values": [
      "Off",
      "On"
    ]
  },
  {
    "name": "Unused",
    "default": 1,
    "values": [
      "Off",
      "On"
    ]
  },
  {
    "name": "BASE Port Address",
    "default": 9,
    "values": [
      "00H",
      "08H",
      "10H",
      "18H",
      "20H",
      "28H",
      "30H",
      "38H",
      "40H",
      "48H",
      "50H",
      "58H",
      "60H",
      "68H",
      "70H",
      "78H",
      "80H",
      "88H",
      "90H",
      "98H",
      "A0H",
      "A8H",
      "B0H",
      "B8H",
      "C0H",
      "C8H",
      "D0H",
      "D8H",
      "E0H",
      "E8H",
      "F0H",
      "F8H"
    ]
  },
  {
    "name": "FLAG2 Polarity",
    "default": 0,
    "values": [
      "Negative",
      "Positive"
    ]
  },
  {
    "name": "FLAG1 Polarity",
    "default": 0,
    "values": [
      "Negative",
      "Positive"
    ]
  },
  {
    "name": "Interrupt",
    "default": 0,
    "values": [
      "Disabled",
      "VI0",
      "VI1",
      "VI2",
      "VI3",
      "VI4",
      "VI5",
      "VI6",
      "VI7",
      "PINT"
    ]
  },
  {
    "name": "Generate PHANTOM Signal",
    "default": 0,
    "values": [
      "Disabled",
      "Enabled"
    ]
  },
  {
    "name": "Bank Select",
    "default": 0,
    "values": [
      "Disabled",
      "DATA 0",
      "DATA 1",
      "DATA 2",
      "DATA 2",
      "DATA 3",
      "DATA 4",
      "DATA 6",
      "DATA 7"
    ]
  },
  {
    "name": "Power Up",
    "default": 0,
    "values": [
      "Inactive",
      "Active"
    ]
  },
  {
    "name": "Power-On Jump",
    "default": 0,
    "values": [
      "Disabled",
      "Enabled"
    ]
  },
  {
    "name": "Bus Speed",
    "default": 0,
    "values": [
      "2 MHz",
      "4/6 MHz"
    ]
  },
  {
    "name": "Phantom Line",
    "default": 0,
    "values": [
      "Disabled",
      "Enabled"
    ]
  },
  {
    "name": "Power-On Jump Address",
    "default": 0,
    "values": [
      "F800H",
      "F000H",
      "E800H",
      "E000H",
      "D800H",
      "D000H",
      "C800H",
      "C000H",
      "B800H",
      "B000H",
      "A800H",
      "A000H",
      "9800H",
      "9000H",
      "8800H",
      "8000H",
      "7800H",
      "7000H",
      "6800H",
      "6000H",
      "5800H",
      "5000H",
      "4800H",
      "4000H",
      "3800H",
      "3000H",
      "2800H",
      "2000H",
      "1800H",
      "1000H",
      "0800H",
      "0000H"
    ]
  },
  {
    "name": "Baud Rate",
    "default": 3,
    "values": [
      "110",
      "1200",
      "9600",
      "19200"
    ]
  },
  {
    "name": "Word Length",
    "default": 1,
    "values": [
      "8 Bits",
      "7 Bits"
    ]
  },
  {
    "name": "Stop Bit Count",
    "default": 0,
    "values": [
      "2 Stop Bits",
      "1 Stop Bit"
    ]
  },
  {
    "name": "Parity",
    "default": 0,
    "values": [
      "Even Parity",
      "Odd Parity"
    ]
  },
  {
    "name": "Parity",
    "default": 0,
    "values": [
      "Off",
      "On"
    ]
  }
]