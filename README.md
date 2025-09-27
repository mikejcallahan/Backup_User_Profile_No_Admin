Goal of this script is to make the transition of a user to a new computer/profile look like nothing happened. It is assumed that the common profile folders Desktop, Documents and Pictures are already syncing to OneDrive. This backup will cover modern program data (saved in c:\users\\<username>\Appdata) Windows 7, 8, 10, 11. 

Includes:
  Installed Applications list,
  Favorites,
  Quick Access,
  Recent File links,
  Downloads (less than 100MB within 31 days),
  Wallpaper,
  Taskbar shortcuts,
  Startup folder,
  Email Signatures,
  Templates,
  Sticky Notes (if not synced to account),

  Some common office apps and browsers: 
  Google Earth,
  Adobe Acrobat,
  Chrome,
  Edge,
  Firefox,
  Brave
  
Variables:
  workingDir:        where files are stored temporarily,
  zipBkupExportPath: destination for final zip file.
  
Main Steps:
1. Direct user to run batch file. (edit instructions according to your spec )
2. Default zip destination is %OneDrive%. Wait for the file to finish uploading before logging out.
3. Log into new profile for user once before logging out and logging back in using a different account. Syncing OneDrive will download the ITbkup.zip file
4. Logged in as different user; Gain access to the user's new profile here C:\users\<username>
5. decompress ITbkup.zip and copy "appdata" into the user profile root.
   
Optional/Special Steps:
1. A copy of Quick Access items are saved in "recentSys" folder. This is the instructions for copying these over manually (backup handles this but things happen so it's nice to have a copy)
   logged in as another user with access, copy the two files "AutomaticDestinations" and "CustomDestinations" into this folder C:\users\\<username>\recent. The Quick Access links should appear when they log in.
   *Quick Access items will not transfer between windows versions. You can update Windows in place to retain them or copy the links manually.
2. Optionally you can restore wallpaper by saving the "TranscodedWallpaper" file as a jpg, and setting it as wallpaper again logged in as them.
3. Optionally you can see an unordered list of taskbar items as the user had them in the "Taskbar(For_Reference)" folder.
