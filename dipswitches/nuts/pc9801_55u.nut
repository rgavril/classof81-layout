return [
  {
    "name": "PC-9801-55: SCSI board ID",
    "default": "7",
    "values": [
      "0",
      "1",
      "2",
      "3",
      "4",
      "5",
      "6",
      "7"
    ]
  },
  {
    "name": "PC-9801-55: Interrupt level",
    "default": "INT3",
    "values": [
      "INT0",
      "INT1",
      "INT2",
      "INT3",
      "INT5",
      "INT6",
      "Unknown",
      "Unknown"
    ]
  },
  {
    "name": "PC-9801-55: DMA channel",
    "default": "0",
    "values": [
      "0",
      "1 (prohibited)",
      "2",
      "3"
    ]
  },
  {
    "name": "PC-9801-55: machine ID and ROM base address",
    "default": "i386, 0xdc000-0xddfff",
    "values": [
      "i386, 0xdc000-0xddfff"
    ]
  },
  {
    "name": "PC-9801-55: ROM accessibility at Power-On",
    "default": "Yes",
    "values": [
      "Yes",
      "No"
    ]
  }
]