/*
maj:
	/- loader une methode au startup qui retourne le root plutot que rappeler l'ini à chaque fois
	-- mettre en place un systeme de versionning des script et ouvrier la dernière version valide
	-- créer deux méthodes générales pour enregistrer et charger les favoris
	--  nettoyer les macroscript
	/- créer un fichier dans le startup de max qui load les methodes souhaité (filein "lasparent.ms")
*/

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
		format  "armada script still exists: %\n" (getMAXIniFile())
	)
)
installAmadasScripts()

-- iconsFolder = ( (getFilenamePath (getMAXIniFile()))) + "usericons"
-- doscommand ("explorer "+ maxIni)


fn copyBmpIcons =
(
	-- copy icon
	-- get icon
	
	maxIni = getMAXIniFile()
	armadasScriptsIni = (getFilenamePath maxIni) + "armadasScriptsIni.ini"
	scriptRoot = getINISetting armadasScriptsIni "armadasScripts" "armadasScriptsRoot"
	iconsArray = getfiles (scriptRoot + "icons\*.bmp")
	
	-- get icon root folder
-- 	iconsRoot = (getdir #maxroot) + "\UI\Icons"
	iconsRoot = ( (getFilenamePath (getMAXIniFile()))) + "ui\\usericons"
	iconsRoot2 = ( (getFilenamePath (getMAXIniFile()))) + "usericons"
		
	existence = getdirectories iconsRoot
	if existence.count == 0 then makedir iconsRoot all:true 
	
	-- make copy
	for icon in iconsArray do
	(
		print icon
		print  (iconsRoot + "\\"+ (filenameFromPath icon))
		
		res = copyFile  icon (iconsRoot + "\\"+ (filenameFromPath icon))
		
			
		if res == true then print "copy done"
		else print "copy fail"
		
		res2 = copyFile  icon (iconsRoot2 + "\\"+ (filenameFromPath icon))
		if res2 == true then print "copy done" else print "copy fail"
	-- 	copyFile  icon iconsRoot 
	)
)
copyBmpIcons()

-- copy du fichier filein type


-- trouver l'adresse du fichiers a copier
fn getRoot =
(
	local maxIni = getMAXIniFile()
	local armadasScriptsIni = (getFilenamePath maxIni) + "armadasScriptsIni.ini"
	local root = getINISetting armadasScriptsIni "armadasScripts" "armadasScriptsRoot"
)
fileInFileSource = (getRoot() +  "armadesFileIn.ms")

-- trouver l'adresse de destination
	-- soit dans le fichier plugin soit ajouter une adresse dans les fichier user "pluginpaths"
count = pluginPaths.count()
for j = 1 to count do format " % : %\n" j (pluginPaths.get j)


-- fileInFileDest = ((GetDir #startupScripts) + "/" + "armadesFileIn.ms")
fileInFileDest = ((GetDir #maxData) + "/scripts/startup/" + "armadesFileIn.ms")

-- suppression du fichier existant
deleteFile fileInFileDest
-- copie
copyFile  fileInFileSource fileInFileDest

format "copy: % to: %\n>>>" fileInFileSource fileInFileDest


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
	
	filein (root +"\\" + "scriptsManager" + "\\" + "scriptsExplorer.ms" )
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
	
	filein (root +"\\" + "scriptsManager" + "\\" + "launcher.ms" )
)


-- install macroscript for asset opener with relative path from ini file
macroScript ArmadasScriptAssetOpener
	category:"ArmadasScripts"
	buttonText: "assetOpener"
	toolTip:""
	icon: #("armadasScriptsAssetOpener",1)
(
	local maxIni = getMAXIniFile()
	local armadasScriptsIni = (getFilenamePath maxIni) + "armadasScriptsIni.ini"
	local root = getINISetting armadasScriptsIni "armadasScripts" "armadasScriptsRoot"
	
	filein (root +"\\" + "assetManager" + "\\" + "assetOpenerUI_v4.ms" )
)


macroScript ArmadasScriptModelingUtilities
	category:"ArmadasScripts"
	buttonText: "modelingUtilities"
	toolTip:""
	icon: #("ArmadasScriptModelingUtilities",1)
(
	local maxIni = getMAXIniFile()
	local armadasScriptsIni = (getFilenamePath maxIni) + "armadasScriptsIni.ini"
	local root = getINISetting armadasScriptsIni "armadasScripts" "armadasScriptsRoot"
	
	filein (root +"\\" + "zz_mode_archi" + "\\" + "misc.ms" )
)
-- "C:/repo_github/DEV_maxscript/00_wip/zz_mode_archi/misc.ms"

macroScript ArmadasScriptMaterialsUtilities
	category:"ArmadasScripts"
	buttonText: "materialsUtilities"
	toolTip:""
	icon: #("ArmadasScriptMaterialsUtilities",1)
(
	local maxIni = getMAXIniFile()
	local armadasScriptsIni = (getFilenamePath maxIni) + "armadasScriptsIni.ini"
	local root = getINISetting armadasScriptsIni "armadasScripts" "armadasScriptsRoot"
	
	filein (root +"\\" + "rendering" + "\\" + "Vray_Script" + "\\" + "deMultiMat.ms" )
)
-- "C:/repo_github/DEV_maxscript/00_wip/rendering/Vray_Script/deMultiMat.ms"

macroScript ArmadasScriptLastParent
	category:"ArmadasScripts"
	buttonText: "lastParent"
	toolTip:""
-- 	icon: #("ArmadasScriptMaterialsUtilities",1)
(
	on execute do
	(
		local sel = selection as array
		lastParent sel
	)
)