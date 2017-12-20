/*
maj:
	/- loader une methode au startup qui retourne le root plutot que rappeler l'ini à chaque fois
	-- mettre en place un systeme de versionning des script et ouvrir la dernière version valide
	-- créer deux méthodes générales pour enregistrer et charger les favoris
	/- créer un fichier dans le startup de max qui load les methodes souhaité (filein "lasparent.ms")
	-- pre load des script avant macro script:
		-- soit dans le fichier plugin soit ajouter une adresse dans les fichier user "pluginpaths": ajouter le chemin au plugin path

	-- déplacer ce script dans le dossier startup pour créer un update à chaque démarrage:
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


-- crée l'armadaScript.ini dans le dossier de 3dsmax et écrit le root des scripts
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

-- trouver l'adresse du dossier à loader au démarage a copier
fn getRoot =
(
	local armadasScriptsIni = (GetDir #maxData) + "armadasScriptsIni.ini"
	local root = getINISetting armadasScriptsIni "armadasScripts" "armadasScriptsRoot"
)



-- ajout de la lecture du dossier startup au démarrage de max (avant macroscript):
fn initArmadasStartupDir =
(
	local startupDir = (getRoot() + "scriptInstaller/startup")

	-- ajout du dossier startup 
	local ini_file = if (maxversion())[1] < 12000 then "plugin.ini" else "plugin.userSettings.ini"
	setINISetting (getdir #maxdata + ini_file) #directories "Armadas Scripts Startup" startupDir
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

-- copy les icones dans le dossier user
fn copyBmpIcons =
(
	-- determine le dossier source	
	local armadasScriptsIni = (GetDir #maxData) + "armadasScriptsIni.ini"
-- 	local	scriptRoot = getRoot()
	
	local iconsArray = getfiles ((getRoot()) + "icons\*.bmp")
	
	-- determine les dossiers de destination
	iconsRoot = (getdir #maxroot) + "\UI\Icons"
-- 	iconsRoot = ( (getFilenamePath (getMAXIniFile()))) + "ui\\usericons"
	iconsRoot = (getdir #maxroot) + "usericons"
-- 	iconsRoot2 = ( (getFilenamePath (getMAXIniFile()))) + "usericons"
	
	-- création du chemin de destination
-- 	existence = getdirectories iconsRoot
-- 	if existence.count == 0 then makedir iconsRoot all:true 
	
	if not doesfileexist iconsRoot then makedir iconsRoot all:true 
	
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
	filein (root +"\\" + "assetManager" + "\\" + "assetOpenerUI_v5.ms" )
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
		if sel.count >= 2 then 	lastParent sel else()
	)
)

macroScript ArmadasScriptCustomIsolate
	category:"ArmadasScripts"
	buttonText: "customIsolate"
	toolTip:"isolate selection without focus on"
-- 	icon: #("ArmadasScriptMaterialsUtilities",1)
(
	local isIsolate = false
	local isolatedList = #()
	
	on execute do
	(
		if not isIsolate then
		(
			for s in $* do
			(
				if not s.ishidden and not s.isselected then
				(
					s.ishidden = true
					append isolatedList s
				)
			)
			isIsolate = true
			format "isolation done\n"
		)
		else if isIsolate then
		(
			for i=isolatedList.count to 1 by - 1 do
			(
				if isvalidnode isolatedList[i] then 
				(
					isolatedList[i].ishidden = false
					deleteitem isolatedList i
				)
			)
			isIsolate = false
			format "isolation end\n"
		)
		else()
		redrawviews ()
	)
	
	on ischecked return isIsolate
)





