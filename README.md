
# Class of '81 Attract-Mode Layout

![Screenshot](https://raw.githubusercontent.com/rgavril/classof81-layout/refs/heads/main/images/screenshot.png)

This attract mode layout mimics the look and functionality of the default interface that came with Arcade1UP's Class of '81 cabinet.

I liked the simplicity of the interface that came with the cabinet, but I hated the limitation of not being able to play some of my favorite games. So, I started learning how to code attract mode layouts and came up with this. It's still a work in progress, but it's functional.

## Disclaimer

This layout was specifically designed for that cabinet and my needs, so there are some limitations that will not make it perfect for everybody. Some I'll change in the future if I feel like it, but others are here to stay.

### Features

-   Configurable dip switches from within the game config menu.
-   Selectable versions (clones) from within the game config menu.
-   Game controls displayed before the game is launched.
-   Intro video when attract mode starts.
    

### Limitations

-   Designed to work for arcade games only. This will not change.
-   Vertical 3/4 layout optimised for 960x1280 resolution.
-   Dip switch options only work with FinalBurn Neo (RetroArch's fbneo core too). Will consider supporting mame but is not a priority for me.
-   All graphics, including the game controls page, are designed for the Class of '81 cabinet.
-   Probably not going to work on Windows, but works fine on Linux/macOS. If you want to have it running on Windows open a Issue and will look into it.
-   Dip Switches and Controls description are not available for all games. They require a json like file to be created. Nothing very hard, I will provide a tutorial when I get some time.
    

## Install and Configure

1.  Download the layout and place it in your attract mode layout folder.
    
2.  In attract mode, go to 'Configure / Displays / Display Edit.' After changing to the new layout, make sure you go to 'Layout Options.' You need to set 'FB Neo Config File' to point to the location of your fbneo config file.
    
3.  In attract mode's 'Configure / General' section, set 'Group Clones' to 'Yes' and 'Hide Brackets in Game Title' to 'Yes.'

4. Your layouts/ folder should be in the same directory with your romlists/ folder. That should be the default so you don't need anything about it. The layout tries to read a file from the romlists/ folder to figure out the clones for a rom.
    

### Note on Attract Mode / RetroPie

-   The layout is compatible with standard attract mode, but I strongly recommend using [Attract Mode Plus](https://github.com/oomek/attractplus). That's what I use, and I’ve noticed better startup times. In the future, I plan to use features that will only be available on that fork of attract mode. Also, that fork is actively maintained.
    
-   There are some effects, like desaturated button logos, that rely on shaders. If your attract mode doesn’t have shader support, all game logos in the menu will display in full color. Note that attract mode in RetroPie doesn’t have shader support.
    
-   If you're using a Raspberry Pi, I suggest using the latest Raspbian (32-bit). Install RetroArch and manually compile attractplus there. I’ve tested it, and attractplus has shader support and works fine on Raspbian. You’ll need some Linux knowledge to do this, but maybe someone could create a tutorial or share an SD image. I’d like to do that, but I don’t have the time right now.