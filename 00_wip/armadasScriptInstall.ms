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

macroScript ArmadasScriptExplorer
	category:"ArmadasScripts"
	buttonText: "ArmadasScriptExplorer"
	toolTip:""
(
	local maxIni = getMAXIniFile()
	local armadasScriptsIni = (getFilenamePath maxIni) + "armadasScriptsIni.ini"
	local root = getINISetting armadasScriptsIni "armadasScripts" "armadasScriptsRoot"
	filein (root +"\\zz_mode_archi\\" + "scriptsExplorer.ms" )
)


macroScript ArmadasScriptLauncher
	category:"ArmadasScripts"
	buttonText: "ArmadasScriptLauncher"
	toolTip:""
(
	local maxIni = getMAXIniFile()
	local armadasScriptsIni = (getFilenamePath maxIni) + "armadasScriptsIni.ini"
	local root = getINISetting armadasScriptsIni "armadasScripts" "armadasScriptsRoot"
	filein (root +"\\zz_mode_archi\\" + "launcher.ms" )
)
-- install macroscript for launcher with relative path from ini file
-- install macroscript for explorer with relative path from ini file