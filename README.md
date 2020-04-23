# close-and-run-amiga68k
Tools for maximizing chip ram when loading Amiga games or applications from floppy on Kickstart 1.3

## The problem...
When booting a floppy disk on Amiga Kickstart 1.3, you lose more than 40KB of chipram that could otherwise be used for a game or other application. This is because the CLI will always open before the startup-sequence is triggered. From Kickstart 2.0 onward, this isn't a problem - the CLI will only open when requested.

## The solution
One solution is of course, to write your game to be entirely system-unfriendly and boot from an NDOS disk.

If that isn't a possibility - for example if you're developing in standard Blitz Basic - the code and binaries in this repository may be of some interest.

### AddChip bootblock
The AddChip bootblock features a variety of tricks to claw back memory - for example, unloading the memory used by external drives DF1-DF3. You can use this to create your boot disk. Using the bootblock will also ensure that the CloseRun utility will work correctly on all KickStarts.

### CloseRun
When used like this:

`closerun the "quick" brown "fox`

CloseRun will load the "quick" and "fox" executables in succession, ignoring text outside of quotes - so it can be used for creative startup-sequence text.

## Other alternatives
As previously mentioned, you may wish to investigate making your game load in an NDOS way.

Add21K restores some of the lost RAM by trashing the CLI's bitplanes. Though of course, you only get 21KB back this way.

The "official" Commodore way will regain a similar amount of memory as CloseRun, though not quite as much. You'll need the tool "Endrun" to open your app after the CLI is closed, and you'll need to run CloseWorkbench() inside your app to actually free the memory.

More information here: http://amigadev.elowar.com/read/ADCD_2.1/AmigaMail_Vol2_guide/node002B.html

## Blitz Basic notes
You still need to run CloseWorkbench_() inside of your Blitz code in order to actually free RAM.

The "WBStartup" command may not be compatible with the AddChip bootblock.

## Acknowledgements
All of the code in this repository comes from Ross and originated on the English Amiga Board - eab.abime.net

