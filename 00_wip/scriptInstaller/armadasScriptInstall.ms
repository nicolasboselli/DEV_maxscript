/*
maj:
	/- loader une methode au startup qui retourne le root plutot que rappeler l'ini � chaque fois
	-- mettre en place un systeme de versionning des script et ouvrir la derni�re version valide
	-- cr�er deux m�thodes g�n�rales pour enregistrer et charger les favoris
	/- cr�er un fichier dans le startup de max qui load les methodes souhait� (filein "lasparent.ms")
	-- pre load des script avant macro script:
		-- soit dans le fichier plugin soit ajouter une adresse dans les fichier user "pluginpaths": ajouter le chemin au plugin path

	-- d�placer ce script dans le dossier startup pour cr�er un update � chaque d�marrage:
		-- nettoyer les macroscripts existants dans le #maxdata
		-- nettoyer le dossier startup de "armadasfilein.ms"

		-- updater le root dans l'armadas script.ini
		-- updater les icons
		-- updater le pluginpath.ini
*/

fn returnParentFolder folderPath =
(
	local splitFolder = filterString folderPath "\\"
	
	local sum = ""
	for i = 1 to (splitFolder.count - 1) do
	(
-- 			print splitFolder[i]
		sum = sum + splitFolder[i] + "\\"
	)
	sum
)


-- cr�e l'armadaScript.ini dans le dossier de 3dsmax et �crit le root des scripts
fn initArmadasScripts =
(
	-- determination du root des scripts
	local armadasScriptsRoot = returnParentFolder (getFilenamePath  (getThisScriptFilename()))
	armadasScriptsRoot = substituteString armadasScriptsRoot "\\" "/"
	format "armadasScriptsRoot: %\n" armadasScriptsRoot
		
	-- determination du dossier max data
	local armadasScriptsIni = (GetDir #maxData) + "armadasScriptsIni.ini"
	-- 
	setINISetting armadasScriptsIni "armadasScripts" "armadasScriptsRoot" armadasScriptsRoot
)
initArmadasScripts()

-- copy les icones dans le dossier user
fn copyBmpIcons =
(
	-- determine le dossier source
	maxIni = getMAXIniFile()
	armadasScriptsIni = (getFilenamePath maxIni) + "armadasScriptsIni.ini"
	scriptRoot = getINISetting armadasScriptsIni "armadasScripts" "armadasScriptsRoot"
	iconsArray = getfiles (scriptRoot + "icons\*.bmp")
	
	-- determine les dossiers de destination
-- 	iconsRoot = (getdir #maxroot) + "\UI\Icons"
	iconsRoot = ( (getFilenamePath (getMAXIniFile()))) + "ui\\usericons"
	iconsRoot2 = ( (getFilenamePath (getMAXIniFile()))) + "usericons"
		
	existence = getdirectories iconsRoot
	if existence.count == 0 then makedir iconsRoot all:true 
	
	-- make copy
	for ic in iconsArray do
	(
-- 		print icon
-- 		format "icon: %\n"  (iconsRoot + "\\"+ (filenameFromPath ic))
		
		local res = copyFile  ic (iconsRoot + "\\"+ (filenameFromPath ic))
		local res2 = copyFile  ic (iconsRoot2 + "\\"+ (filenameFromPath ic))
		
			
		if res == true then format "copy in \"ui\\usericons\" done : %\n" ic
		else format "copy in \"ui\\usericons\" fail: %\n" ic
		
		if res == true then format "copy in \"usericons\" done : %\n" ic
		else format "copy in \"usericons\" fail: %\n" ic
		
	-- 	copyFile  icon iconsRoot 
	)
)
copyBmpIcons()

-- copy du fichier filein type


-- trouver l'adresse du dossier � loader au d�marage a copier
fn getRoot =
(
	local maxIni = getMAXIniFile()
	local armadasScriptsIni = (getFilenamePath maxIni) + "armadasScriptsIni.ini"
	local root = getINISetting armadasScriptsIni "armadasScripts" "armadasScriptsRoot"
)

-- aout de la lecture du dossier startup au d�marrage de max (avant macroscript):
fn initArmadasStartupDir =
(
	startupDir = (getRoot() + "scriptInstaller/startup")

	-- ajout du dossier startup 
	ini_file = if (maxversion())[1] < 12000 then "plugin.ini" else "plugin.userSettings.ini"
	setINISetting (getdir #maxdata + ini_file) #directories "Armadas Scripts Startup"startupDir
)
initArmadasStartupDir()

/*
-- fileInFileSource = (getRoot() + "scriptInstaller/armadesFileIn.ms")
-- trouver l'adresse de destination
	-- soit dans le fichier plugin soit ajouter une adresse dans les fichier user "pluginpaths"

-- fileInFileDest = ((GetDir #startupScripts) + "/" + "armadesFileIn.ms")
fileInFileDest = ((GetDir #maxData) + "scripts/startup/" + "armadesFileIn.ms")

-- suppression du fichier existant
if doesfileexist fileInFileDest then deleteFile fileInFileDest
-- copie
copyDone = copyFile  fileInFileSource fileInFileDest
format "copy: % to: %\ncopy done: %\n" fileInFileSource fileInFileDest copyDone
*/


-- install macroscript

-- install macroscript for explorer with relative path from ini file
macroScript ArmadasScriptExplorer
	category:"ArmadasScripts"
	buttonText: "MSXexplorer"
	toolTip:""
	icon: #("armadasScriptsExplorer",1)
(
	local root = getroot()
	filein (root +"\\" + "scriptsManager" + "\\" + "scriptsExplorer.ms" )
)

-- install macroscript for launcher with relative path from ini file
macroScript ArmadasScriptLauncher
	category:"ArmadasScripts"
	buttonText: "MSXlauncher"
	toolTip:""
	icon: #("armadasScriptsFavorites",1)
(
	local root = getroot()	
	filein (root +"\\" + "scriptsManager" + "\\" + "launcher.ms" )
)


-- install macroscript for asset opener with relative path from ini file
macroScript ArmadasScriptAssetOpener
	category:"ArmadasScripts"
	buttonText: "assetOpener"
	toolTip:""
	icon: #("armadasScriptsAssetOpener",1)
(
	local root = getroot()
	filein (root +"\\" + "assetManager" + "\\" + "assetOpenerUI_v4.ms" )
)


macroScript ArmadasScriptModelingUtilities
	category:"ArmadasScripts"
	buttonText: "modelingUtilities"
	toolTip:""
	icon: #("ArmadasScriptModelingUtilities",1)
(
	local root = getroot()
	filein (root +"\\" + "zz_mode_archi" + "\\" + "misc.ms" )
)
-- "C:/repo_github/DEV_maxscript/00_wip/zz_mode_archi/misc.ms"

macroScript ArmadasScriptMaterialsUtilities
	category:"ArmadasScripts"
	buttonText: "materialsUtilities"
	toolTip:""
	icon: #("ArmadasScriptMaterialsUtilities",1)
(
	local root = getroot()
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