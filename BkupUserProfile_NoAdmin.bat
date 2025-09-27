@echo off

rem WHERE FILES ARE STORED DURING BACKUP PROCESS
set workingDir="%userprofile%\IT-Temp\ITbkup"

rem WHERE PROFILE BACKUP ZIP FILE IS SAVED
set zipBkupExportPath="%OneDrive%"

echo " ___________________________________________________________"
echo "  User Profile Backup  (Tested in Windows 7, 10 & 11)                 "
echo "                                                            "
echo "            ____________________________________            "
echo "            |_____IMPORTANT PLEASE READ________|            "
echo "                                                            "
echo "  This script will NOT back up most of the files you see.   "
echo "  That's what OneDrive is for. You should see little check- "
echo "  -marks or cloud icons on your PC files which means those  "
echo "  files are backed up to OneDrive. If you don't see those:  "
echo "  Contact helpdesk                            "
echo "____________________________________________________________"
echo .
echo .                                                          
echo .
   	 pause       
echo .
echo .                                                          
echo .
echo .
echo .                                                          
echo .
echo .
echo .                                                          
echo .
echo .
echo .                                                          
echo .
echo .
echo .                                                          
echo .
echo "____________________________________________________________"
echo " <<<<| PLEASE CLOSE ALL APPLICATIONS BEFORE CONTINUING |>>>>"
echo " <<<<| If you click away, make this window active again|>>>>"
echo " <<<<| by clicking the title bar before continuing     |>>>>"
echo " <<<<|_________________________________________________|>>>>"
echo .                                                          
echo .
echo .
echo .                                                          
echo .
echo .
echo .                                                          
echo .
echo .
echo .                                                          
echo .
	pause


mkdir %workingDir%
break>"%workingDir%\bkuplog.txt"


echo "_____GET SOFTWARE LIST____"
set argGetApps="set-ExecutionPolicy -ExecutionPolicy bypass -scope process -force;$pth=\"%workingDir%\"; if(!(test-path -path $pth)){ new-item -itemtype \"Directory\" -path $pth | out-null };try{get-package -Provider Programs -includewindowsinstaller | Select-Object \"Name\", \"Version\", \"Summary\", \"CanonicalId\", \"InstallLocation\", \"InstallDate\", \"UninstallString\", \"QuietUninstallString\", \"ProductGUID\" | export-csv -path (\"%workingDir%\\\" + \"$($env:COMPUTERNAME)\" + \"(\" + ((& {wmic bios get serialnumber;}) -join \"\" -replace(\"SerialNumber\",\"\") -replace(\" \",\"\")) + \")_$(($env:USERNAME).toUpper())_\" + \"APPS\" + \".csv\") -notypeinformation -force | out-null;}catch{write-host(\"$error[0]\")}"

powershell -command %argGetApps%
		 

echo "_____COPY SID FOLDER (REFERENCE)_______"
robocopy %userprofile%\AppData\Roaming\Microsoft\Crypto\RSA "%workingDir%\SID" /xf * /E
		
echo "_____DEVICE_GUID_________"
robocopy %userprofile%\AppData\Local\Publishers\8wekyb3d8bbwe\DeviceId "%workingDir%" DeviceId.txt /np 

echo "_____IE FAVORITES____"
robocopy %userprofile%\Favorites "%workingDir%\Favorites" /E /np 

echo "_____LINKS____"
robocopy  %userprofile%\Links %workingDir%\Links /e /np 

GOTO comment
echo "_____MUSIC______"
robocopy %userprofile%\Music %workingDir%\Music /e /np 
:comment

echo "_____QUICK ACCESS________(drag to profile root)_____" 
robocopy %userprofile%\recent\automaticdestinations "%workingDir%\recentSys\automaticdestinations" /e /np 
robocopy %userprofile%\recent\customdestinations "%workingDir%\recentSys\customdestinations" /e /np 
	
echo "_____QuickAccess(if_Profile_External < this actually works better)_________"	
robocopy %userprofile%\appdata\roaming\microsoft\windows\recent\automaticdestinations "%workingDir%\appdata\roaming\microsoft\windows\recent\automaticdestinations" /e /np 
robocopy %userprofile%\appdata\roaming\microsoft\windows\recent\customdestinations "%workingDir%\appdata\roaming\microsoft\windows\recent\customdestinations" /e /np 

echo "_____RECENT_FILES(restoring this will include Quick Access - need to test with xcopy ____"
robocopy %userprofile%\recent "%workingDir%\recent" /e /np 
robocopy %userprofile%\AppData\Roaming\Microsoft\Office\Recent "%workingDir%\AppData\Roaming\Microsoft\Office\Recent" /e /np 

echo "_____DOWNLOADS (less than 100MB within last 31 days)_____"
robocopy %userprofile%\downloads "%workingDir%\DownloadsOLD" /max:100000000 /maxage:31 /xf *.exe *.msi *.tif /E /np 

echo "_____WALLPAPER(JPG without extension)_______"
robocopy %userprofile%\AppData\Roaming\Microsoft\Windows\Themes "%workingDir%" TranscodedWallpaper /e /np 

echo "_____TASKBAR(for reference only)______"
robocopy "%userprofile%\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar" "%workingDir%\TaskBar(For_Reference)" /E /np 

echo "_____APPDATA-PROGRAMS (nope)______"
	GOTO comment		
	robocopy "%userprofile%\AppData\Local\Programs" "%workingDir%\AppData\Local\Programs" /E /np 
	:comment

echo "_____STARTUP______"
robocopy "%userprofile%\AppData\roaming\Microsoft\Windows\Start Menu\Programs\Startup" "%workingDir%\AppData\roaming\Microsoft\Windows\Start Menu\Programs\Startup" /E /np 

echo "_____SIGNATURES______"
echo"Signatures now in 365 instead - still backing up old location in appdata\\roaming"
robocopy "%userprofile%\AppData\Roaming\Microsoft\Signatures" "%workingDir%\Appdata\Roaming\Microsoft\Signatures" /E /np 

echo "_____TEMPLATES________"
robocopy %userprofile%\AppData\Roaming\Microsoft\Templates "%workingDir%\AppData\Roaming\Microsoft\Templates" *.xltm *.dotm /E /np 

echo "_____STICKY NOTES(if not synced with account)____"
robocopy "%userprofile%\AppData\Local\Packages\Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe\LocalState" "%workingDir%\AppData\Local\Packages\Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe\LocalState" /xf *log* /E /np 

	goto comment
	echo"________GET ODDBALL USER FOLDERS STILL IN ROOT____"
	echo"_______DOCUMENTS DIR IN ROOT ([old software or hard links cause this] <100MB no installers - exclude junctions)_____"
	robocopy %userprofile%\documents "%workingDir%\Documents(ProfileRoot)" /max:100000000 /xf *.exe *.zip *.sys /xd *"My Music"* *"My Videos"* *"My Pictures"*  /e /np 
	echo"_______C ROOT TREE (for reference- might have old software dirs)___"			
	mkdir "%workingDir%\ctree"
	mkdir "%workingDir%\ProfileTree"
	echo "______USERPROFILE TREE______"	
	powershell Copy-Item -LiteralPath ("\\"+"$($env:COMPUTERNAME\c)\") -Destination "%workingDir%\ctree" -Filter {PSIsContainer -eq $true}
	powershell Copy-Item -LiteralPath "$($env:USERPROFILE)" -Destination ("$($env:USERPROFILE)" + "\it-temp\itbkup\ProfileTree") -recurse -Filter {PSIsContainer -eq $true}
	:comment	

echo "_____ADOBE_APPS(VERSION_AGNOSTISM_PENDING)_________"
echo "_____ADOBE________"
robocopy "%userprofile%\AppData\Roaming\Adobe\Acrobat\DC\Security" "%workingDir%\AppData\Roaming\Adobe\Acrobat\DC\Security" *.pdf *.pfx /E /np 
robocopy "%userprofile%\AppData\Roaming\Adobe\Acrobat\DC\UserPrefs" "%workingDir%AppData\Roaming\Adobe\Acrobat\DC\UserPrefs" /e /np 
robocopy "%userprofile%\AppData\Roaming\Adobe\CameraRaw\Defaults" "%workingDir%\AppData\Roaming\Adobe\CameraRaw\Defaults" Preferences.xmp /e /np 
robocopy "%userprofile%\AppData\Roaming\Adobe\Photoshop Elements\12.0\Editor" "%workingDir%\AppData\Roaming\Adobe\Photoshop Elements\12.0\Editor" "Adobe Photoshop Elements 12 Prefs.psp" /np 
robocopy "%userprofile%\AppData\Roaming\Adobe\Plugins" "%workingDir%\AppData\Roaming\Adobe\Plugins" /e /np 
robocopy "%userprofile%\AppData\Roaming\Adobe\Acrobat\DC\Stamps" "%workingDir%\AppData\Roaming\Adobe\Acrobat\DC\Stamps" /e /np 
				
echo "_____INDESIGN__________"	
robocopy "%userprofile%\appdata\Roaming\Adobe\InDesign\Version 18.0\en_US" "%workingDir%\appdata\Roaming\Adobe\InDesign\Version 18.0\en_US" AppPrefs.xml /e 

echo "_____ARCGIS USER PROFILE (ArcGISPro.exe_StrongName_<STRONGNAME>\<VERSIONNUMBER>)______" 
robocopy "%userprofile%\AppData\Roaming\Esri" "%workingDir%\AppData\Roaming\Esri" ArcGISPro.exe_StrongName_* /E /xd *cache* *log* *temp* /np 

echo "_____ARCGIS (Favorites/History)______"
robocopy "%userprofile%\AppData\Local\ESRI\ArcGISPro\Favorites" "%workingDir%\Appdata\Local\ESRI\ArcGISPro\Favorites" /E /np 
robocopy "%userprofile%\AppData\Local\ESRI\ArcGISPro\Geoprocessing\UserFavorites" "%workingDir%\AppData\Local\ESRI\ArcGISPro\Geoprocessing\UserFavorites" UserFavorites.xml /E /np 
robocopy "%userprofile%\AppData\Local\ESRI" "%workingDir%\Appdata\Local\ESRI" ArcGISSettings.xml /E /np
		  goto comment
robocopy "%userprofile%\AppData\Local\ESRI\index\config" "%workingDir%\Appdata\Local\ESRI\Index\config" 
			:comment
robocopy "%userprofile%\AppData\Roaming\Esri\ArcGISPro\ArcToolbox" "%workingDir%\AppData\Roaming\Esri\ArcGISPro\ArcToolbox" /xd *cache* *conda* /xf *cache* *log* *temp* /e /np 

echo"_____AQUA4PLUS_______"
robocopy "%userprofile%\AppData\Roaming\Aqua4Plus" "%workingDir%\AppData\Roaming\Aqua4Plus" /E	/np 

echo"_____BLUEBEAM REVU 2018_____"
robocopy "%userprofile%\AppData\Roaming\Bluebeam Software\Revu\18" "%workingDir%\AppData\Roaming\Bluebeam Software\Revu\18" /E /np 

echo"_____BLUEBEAM REVU '20______"
	GOTO comment
	rem pruning needed
	robocopy %userprofile%\AppData\Local\Bluebeam\Revu\20 "%workingDir%\AppData\Local\BluebeamRevu\20" /xd *cache* /xf *cache* *log* /E /np 
	:comment
robocopy "%userprofile%\AppData\Roaming\Bluebeam Software\Revu\20" "%workingDir%\AppData\Roaming\Bluebeam Software\Revu\20" /xd *cache* /xf *cache* *log* /E /np 

echo "____CIVIL3D 2018______"
echo "____C3D_LOCAL_________"
robocopy "%userprofile%\AppData\Local\Autodesk\C3D 2018\enu\Project Management" "%workingDir%\AppData\Local\Autodesk\C3D 2018\enu\Project Management" /e /np 
robocopy "%userprofile%\AppData\Local\Autodesk\C3D 2018\enu\Recent" "%workingDir%\AppData\Local\Autodesk\C3D 2018\enu\Recent" /e /np 

	GOTO comment
	rem this is hardware specific
	robocopy "%userprofile%\AppData\Roaming\Autodesk\CIV3D\2018" "%workingDir%\AppData\Roaming\Autodesk\CIV3D\2018" /e
	:comment

	GOTO comment
	rem lots of xd to add for c3d2018 roaming - will run very long currently - log to find
	:comment
robocopy "%userprofile%\AppData\Roaming\Autodesk\C3D 2018" "%workingDir%\AppData\Roaming\Autodesk\C3D 2018" /e /xd "%userprofile%\AppData\Roaming\Autodesk\C3D 2018\enu\Support" "%userprofile%\AppData\Roaming\Autodesk\C3D 2018\enu\ErrorLogs" "%userprofile%\AppData\Roaming\Autodesk\C3D \2018\enu\Support" /np 

echo "_____CIVIL3D 2018_ROAMING______"
robocopy "%userprofile%\AppData\Roaming\Autodesk\C3D 2018\enu\Recent" "%workingDir%\AppData\Roaming\Autodesk\C3D 2018\enu\Recent" /np 
robocopy "%userprofile%\AppData\Roaming\Autodesk\C3D 2018\enu\Support\Profiles" "%workingDir%\AppData\Roaming\Autodesk\C3D 2018\enu\Support\Profiles" /e /np 
	
	GOTO comment
	rem not needed/too many generics
	robocopy "%userprofile%\AppData\Roaming\Autodesk\C3D 2018\enu\Support\AuthorPalette\Palettes" "%workingDir%\AppData\Roaming\Autodesk\C3D 2018\enu\Support\AuthorPalette\Palettes" /e /np 
	:comment
echo "_____CIVIL3D 2022____"
robocopy "%userprofile%\AppData\Roaming\Autodesk\C3D 2022\enu\Recent" "%workingDir%\AppData\Roaming\Autodesk\C3D 2022\enu\Recent" /e /np 
robocopy "%userprofile%\AppData\Roaming\Autodesk\C3D 2022\enu\Project Management" "%workingDir%\AppData\Roaming\Autodesk\C3D 2022\enu\Project Management" /e /np 
robocopy "%userprofile%\AppData\Roaming\Autodesk\C3D 2022\enu\Support\Profiles" "%workingDir%\AppData\Roaming\Autodesk\C3D 2022\enu\Support\Profiles" /e /np 

echo "_____GOOGLE EARTH____"
robocopy "%userprofile%\AppData\LocalLow\Google\GoogleEarth" "%workingDir%\AppData\LocalLow\Google\GoogleEarth" *.kml /E /np 

echo "_____LUMION____"
robocopy "%userprofile%\AppData\Local" ""%workingDir%\AppData\Local /np 

echo "_____SKETCHUP_____"
robocopy "%userprofile%\AppData\Local\SketchUp" "%workingDir%\AppData\Local\SketchUp" PrivatePreferences.json /E /np 

echo "_____WWHM_____"
robocopy "%userprofile%\AppData\Roaming\WWHM2012" "%workingDir%\AppData\Roaming\WWHM2012" /E /np 

rem echo"________GEOTECH (get this)______"

echo "BROWSERS:"
echo"____GOOGLE CHROME (Passwords won't backup - need to export)_________"
robocopy "%userprofile%\AppData\Local\Google\Chrome\User Data\Default" "%workingDir%\AppData\Local\Google\Chrome\User Data\Default" "Favicons" "History" "Bookmarks" "Passwords" "Login Data" "Login Data For Account" "Login Data For Account-journal" "Preferences" "Shortcuts" "Top Sites" "Visited Links" "Web Data" "trusted_vault.pb" "PreferredApps" "Affiliation Database" /xd *cache* *temp* /xf *log* *cache* /E /np 

echo "_____BRAVE________"
robocopy "%userprofile%\AppData\Local\BraveSoftware\Brave-Browser\User Data\Default\User Data\Default" "%workingDir%\AppData\Local\BraveSoftware\Brave-Browser\User Data\Default" "Bookmarks" "History" "Login Data" "Login Data For Account" "Login Data For Account-journal" "Preferences" "Shortcuts" "Top Sites" "Visited Links" "Web Data" trusted_vault.pb "PreferredApps" "Affiliation Database" /E /np 

echo "_____Firefox______(work in progress - bookmarks include restricted characters backup manually)_______"
robocopy "%userprofile%\AppData\Roaming\Mozilla\Firefox\Profiles" "%workingDir%\AppData\Roaming\Mozilla\Firefox\Profiles" "addons.json" "places.sqlite" "bookmarkbackups" "favicons.sqlite" "key4.db" "logins.json" "permissions.sqlite" "content-prefs.sqlite" "search.json.mozlz4" "persdict.dat" "formhistory.sqlite" "extensions" "cert9.db" "pkcs11.txt" "handlers.json" "sessionstore.jsonlz4" "xulstore.json" "prefs.js" "containers.json" "storage.sqlite" *.jsonlz4 /e /xd "*+*" /np 

echo "_____EDGE USER DATA(some prefs not synced by default in managed browser)______"
robocopy "%userprofile%\AppData\Local\Microsoft\Edge\User Data\Default" "%workingDir%\AppData\Local\Microsoft\Edge\Default" "Favicons" "Favicons-journal" "History" "History-journal" "Bookmarks" "Preferences" "Shortcuts" "Top Sites" "Top Sites-journal" "Visited Links" "Web Data" "PreferredApps" "Affiliation Database" /xd "Cache" "databases" "Service Worker" "blob_storage" "Local Storage" "Storage" /xf "*.db" /e /np 

echo "_____EDGE APPS (these backup but restoration is convoluted - Most don't use this)____"
robocopy "%userprofile%\AppData\Local\Microsoft\Edge\User Data\Default\Web Applications" "%workingDir%\AppData\Local\Microsoft\Edge\User Data\Default\Web Applications" /xd *cache* "Service Worker" /xf *log* *temp* /e /np 

GOTO comment
echo "_____ZOOM_________"
robocopy "%userprofile%\AppData\Roaming\Zoom\data" "%workingDir%\AppData\Roaming\Zoom\data" "client.config" /E /np 

echo "_____JABRA DIRECT____"
robocopy "%userprofile%\AppData\Roaming\Jabra Direct" "%workingDir%\appdata\roaming\jabra direct" "config.json" /np 
:comment		

echo "_____BEAM ME UP_________"

mkdir "%zipBkupExportPath%"

powershell Compress-Archive -Path "%workingDir%" -CompressionLevel Fastest -DestinationPath "%zipBkupExportPath%\ITbkup.zip" -force
REM robocopy "%userprofile%\IT-Temp" "%OneDrive%\ITbkup" ITbkup.zip /is /it /im /np 

goto comment
rem THIS WILL DELETE THE WORKING DIRECTORY AFTER. 
rd /s /q "%userprofile%\IT-Temp"
:comment

echo .
echo .                                                          
echo .
echo .
echo .                                                          
echo .
echo .
echo .                                                          
echo .
echo .  
echo . 
echo .
echo . 
echo . 
echo . 
echo . 
echo . 
echo . 
echo . 
echo . 
echo . 
echo . 
echo . 
echo . 
echo . 
echo . 
echo . 
echo . 
echo . 
echo . 
echo .
echo . 
echo . 
echo . 
echo .
echo . 
echo . 
echo . 
echo .

echo ">>>>>>>>>>>>>>>>>>>>>>IMPORTANT PLEASE READ <<<<<<<<<<<<<<<<<<<<<<<<<"
echo "___________________________________________________________________"
echo "           Microsoft Edge Only (On New Machines) Policy            "
echo "___________________________________________________________________"
echo " 1. PLEASE HIGHLIGHT, COPY & THEN PASTE (Ctrl + C / Ctrl + V)      "
echo "    THE ADDRESS BELOW INTO EDGE.                                   "
echo " 		edge://settings/profiles                                 "
echo "                                                                   "                                                                        
echo " 2. MAKE SURE YOU ARE SIGNED INTO EDGE ITSELF AND "Sync" is ON     "
echo "                                                                   " 
echo "     *If your PBS account isn't shown under "Your Profile", select "
echo "      "Sign in". Choose option to keep current Edge data (if asked)"    
echo "      turn "Sync" ON                                               "
echo .
echo .
echo "___________________________________________________________________"
echo ">>>>>>>>>>>>>>>>CONTINUE FOR FURTHER INSTRUCTIONS <<<<<<<<<<<<<<<<<"
echo "___________________________________________________________________"
echo .
echo .
echo .
echo .                                                          
echo .
echo .
echo .                                                          
pause
echo .
echo .                                                          
echo .
echo .
echo .                                                          
echo .
echo .
echo .                                                          
echo .
echo .
echo .                                                          
echo .
echo .
echo .                                                          
echo .
echo .
echo .                                                          
echo _________
echo "_________HOW TO COPY OVER OTHER BROWSER DATA INTO EDGE_________"
echo "           (BOOKMARKS/FAVORITES, PASSWORDS, HISTORY)           "
echo "                  |_______OPTION A_______|                     "
echo "_______ADDING TO MAIN [WORK] EDGE PROFILE (CONSOLIDATING)______"
echo "       **************************************************      "
echo "     1. NAVIGATE TO THIS ADDRESS                               "
echo "                edge://settings/profiles/importBrowsingData    "
echo "     2. SELECT "IMPORT FROM OTHER BROWSERS"                    "
echo "          From dropdown choose Chrome, IE or CSV/HTML import.  "
echo "          For other browsers exporting data to HTML/CSV varies."
echo "          Can usually find the option on the Bookmarks, History"
echo "          or Passwords page in Settings for respective browser "
echo "                   ______                      "
echo "                   |______OPTION B______|                      "
echo "_______SAVE DATA TO ADD LATER TO [PERSONAL] EDGE PROFILE_______"
echo "       *************************************************       "
echo "     1. [IN CHROME] If sync is "ON" these steps arn't neccessary"
echo "        If you use a different browser search online for tutorial" 
echo "        NAVIGATE TO THESE ADDRESSES:                           "
echo "                chrome://bookmarks                             "
echo "                chrome://settings/passwords                    "
echo "     2. SELECT 3 DOTS >> "EXPORT BOOKMARKS"/"EXPORT PASSWORDS  "
echo "                                                               "
echo "     3. SAVE THEM IN ITbkup folder in OneDrive folder          "
echo "        if i see them i will import them into a personal Edge  "
echo "        profile on your new computer.                          "
pause
echo . 
echo . 
echo . 
echo .
echo . 
echo . 
echo . 
echo .
echo . 
echo . 
echo . 
echo .
echo . 
echo . 
echo . 
echo .
echo . 
echo . 
echo . 
echo .
echo . 
echo . 
echo . 
echo .
echo . 
echo . 
echo . 
echo " ________BACKUP IS COMPLETE._______" 
echo " _______PLEASE CHECK ONEDRIVE ICON NEXT TO CLOCK TO MAKE SURE IT'S________"
echo " _______DONE SYNCING THE BACKUP BEFORE GOING OFFLINE______"
echo . 
echo . 
echo . 
echo .
echo . 
echo . 
echo . 
echo .
echo . 
echo . 
echo . 
echo .
echo . 
echo . 
echo . 
echo .

pause
