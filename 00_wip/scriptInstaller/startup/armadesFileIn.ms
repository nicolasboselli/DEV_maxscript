/*
doc:
	-- ce fichier 
		- 1 - preload les fonctions necessaire � faire fonctionner les macros
		- 2 -  supprime les macros existantes
		- 3 -  installe le macros et les icones
	
	Le fichier est utilis� � la premi�re installation et � chaque ouverture de max

maj:
	x- loader une methode au startup qui retourne le root plutot que rappeler l'ini � chaque fois (getRoot)
	/- cr�er deux m�thodes g�n�rales pour enregistrer et charger les favoris
	/- cr�er un fichier dans le startup de max qui load les methodes souhait� (filein "lasparent.ms")
	x- pre load des script avant macro script:
		x- soit dans le fichier plugin soit ajouter une adresse dans les fichier user "pluginpaths": ajouter le chemin au plugin path

	/- d�placer ce script dans le dossier startup pour cr�er un update � chaque d�marrage:
		-- nettoyer les macroscripts existants dans le #maxdata
		-- nettoyer le dossier startup de "armadasfilein.ms"

		-- updater le root dans l'armadas script.ini
		-- updater les icons
		-- updater le pluginpath.ini

	-- mettre en place un systeme de versionning des script et ouvrir la derni�re version valide
	-- cr�er une table pour lister les versions de script � loader dans les macroscript
		-- permet de porposer une table wip/debug/published
		-- s'appuie sur le versionnement dans des dossiers
		-- propose de faire la bascule entre wip/debup/published
		--permet d'accorder des autorisations
*/

-- ########## PRELOAD DES FONCTIONS
fn getRoot =
(
	local armadasScriptsIni =  (GetDir #maxData) + "armadasScriptsIni.ini"
	local root = getINISetting armadasScriptsIni "armadasScripts" "armadasScriptsRoot"
)


-- load function pour parenter comme dans maya
filein ((getRoot ()) + "Rig/lastParent_def.ms")

-- load function pour enregistrer et loader les pr�ferences
filein ((getRoot ()) + "rollout_pref/rollout_pref.ms")

-- load de la fonction pour isoler la selection sans faire de focus dessus
filein ((getRoot ()) + "sceneManagement/isolateSlectionCustom.ms")


-- ########## UPDATE DES MACROS
-- copy les icones des macros dans le dossier user
fn copyBmpIcons =
(
	local iconsArray = getfiles ((getRoot()) + "icons\*.bmp")
	
	-- determine les dossiers de destination
	iconsRoot = (getdir #maxdata) + "\UI\Icons"
	if not doesfileexist iconsRoot  then makedir iconsRoot all: true
	
	iconsRoot2 = (getdir #maxdata) + "usericons"
	if not doesfileexist iconsRoot2  then makedir iconsRoot2 all: true	
	
	-- make copy
	for ic in iconsArray do
	(		
		local res = copyFile  ic (iconsRoot + "\\"+ (filenameFromPath ic))	
		if res == true then format "copy in \"\UI\Icons\" done : %\n" ic
		else format "copy in \"\UI\Icons\" fail: %\n" ic
		
		local res2 = copyFile  ic (iconsRoot2 + "\\"+ (filenameFromPath ic))
		if res2 == true then format "copy in \"usericons\" done : %\n" ic
		else format "copy in \"usericons\" fail: %\n" ic
		
	-- 	copyFile  icon iconsRoot 
	)
)
copyBmpIcons()

-- nettoyage des macroscripts existant
useMacrosPath =  (getdir #maxdata) + "\usermacros"
armadasMacroAr = #()

if doesfileexist useMacrosPath then
(
	armadasMacroAr = getfiles ((getdir #maxdata) + "\usermacros\ArmadasScripts*")
)
for macro in armadasMacroAr do format "%\n" macro
	
-- load du fichier de macros
filein ((getRoot ()) + "scriptInstaller/armadasMacrosList.ms")



