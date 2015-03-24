-- create script ini file near of 3dsmax ini file

fn installAmadasScripts =
(
	local maxIni = getMAXIniFile()
	local armadasScriptsIni = (getFilenamePath maxIni) + "armadasScriptsIni.ini"

	if doesFileExist armadasScriptsIni == false then
	(
		-- get root path
		modeArchiScriptRoot = getFilenamePath  (getThisScriptFilename() )
		-- write init
		setINISetting armadasScriptsIni "armadasScripts" "armadasScriptsRoot" modeArchiScriptRoot
	)
	else
	(
		print "armada script still exists"
	)
)

installAmadasScripts()


fn copyBmpIcons =
(
	-- copy icon
-- get icon
	maxIni = getMAXIniFile()
	armadasScriptsIni = (getFilenamePath maxIni) + "armadasScriptsIni.ini"
	scriptRoot = getINISetting armadasScriptsIni "armadasScripts" "armadasScriptsRoot"
	iconsArray = getfiles (scriptRoot + "\icons\*.bmp")

	-- get icon root folder
	iconsRoot = (getdir #maxroot) + "\UI\Icons"

	-- make copy
	for icon in iconsArray do
	(
		copyFile  icon (iconsRoot + "\\"+ (filenameFromPath icon))
	-- 	copyFile  icon iconsRoot 
	)
)
copyBmpIcons()

-- install macroscript

-- install macroscript for explorer with relative path from ini file
macroScript ArmadasScriptExplorer
	category:"ArmadasScripts"
	buttonText: "MSXexplorer"
	toolTip:""
	icon: #("armadasScriptsExplorer",1)
(
	local maxIni = getMAXIniFile()
	local armadasScriptsIni = (getFilenamePath maxIni) + "armadasScriptsIni.ini"
	local root = getINISetting armadasScriptsIni "armadasScripts" "armadasScriptsRoot"
	filein (root +"\\zz_mode_archi\\" + "scriptsExplorer.ms" )
)

-- install macroscript for launcher with relative path from ini file
macroScript ArmadasScriptLauncher
	category:"ArmadasScripts"
	buttonText: "MSXlauncher"
	toolTip:""
	icon: #("armadasScriptsFavorites",1)
(
	local maxIni = getMAXIniFile()
	local armadasScriptsIni = (getFilenamePath maxIni) + "armadasScriptsIni.ini"
	local root = getINISetting armadasScriptsIni "armadasScripts" "armadasScriptsRoot"
	filein (root +"\\zz_mode_archi\\" + "launcher.ms" )
)

