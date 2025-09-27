Goal of this script is to make the transition of a user to a new computer/profile look like nothing happened.

Includes:
  Favorites
  Quick Access
  Recent File links
  Downloads (less than 100MB within 31 days)
  Wallpaper
  Taskbar shortcuts
  Startup folder
  Email Signatures
  Templates
  Sticky Notes (if not synced to account )

  Some common office apps and browsers: 
  Google Earth
  Adobe Acrobat
  Chrome
  Edge
  Firefox
  Brave

Variables:
  workingDir:        where files are stored temporarily
  zipBkupExportPath: destination for final zip file.
Steps:
1. Direct user to run batch file. (edit instructions according to your spec )
2. Default zip destination is %OneDrive%. Wait for the file to finish uploading before logging out.
3. Log into new profile for user once before logging out and logging back in using a different account.
4. Logged in as different user; Gain access to the user's new profile here C:\users\<username>
5. Drag and drop folders into the user profile root.
6. If Quick Access items are missing you can restore Quick Access list by opening "recentSys" folder
   and dragging and dropping the two files "AutomaticDestinations" and "CustomDestinations" into C:\users\<username>\recent.
   *Quick Access items will not transfer between windows versions.
7. Optionally you can restore wallpaper by saving the "TranscodedWallpaper" file as a jpg, and setting it as wallpaper again logged in as them.
8. Optionally you can see an unordered list of taskbar items as the user had them in the "Taskbar(For_Reference)" folder.
