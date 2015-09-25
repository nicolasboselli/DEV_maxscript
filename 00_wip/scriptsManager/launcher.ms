/*
-- maj:
	-- remove favorite
	x-- catch obsolete path, cleaner at opening 
	-- update on closing
	-- add selection set:
		-- default/all is "armadasScriptsArray=#"
		-- create set, delete set, add script to selected set remove script from selected set
*/

-- with printAllElements on propArVal as string

fn sortbyname v1 v2 =
(
	-- qsort <array> sortbyname
-- 	vars
	local d
	
	if ( (toLower v1.name) < (toLower v2.name)) then
		d=-1
	else
		d=1
	
--compare les numeros entre eux et les classe	
	case of
	(
		(d < 0.): -1
		(d > 0.): 1
		default: 0
	)
)

try(destroyDialog mxsLaunchRLT)catch()

struct favFileClass
(
	path,
	name = getFilenameFile path,
	
	fn launch =
	(
		if doesfileexist path then
		(
		filein path
		)
		else
		(
			print "no script"
		)
	)
)


rollout mxsLaunchRLT "maxscript launcher"
(
-- 	local var = checkIniFileFn()
	local btnLine1 = 450
	
	local maxIni = getMAXIniFile()
	local armadasScriptsIni = (getFilenamePath maxIni) + "armadasScriptsIni.ini"
	
	local tmpRoot = getINISetting armadasScriptsIni "armadasScripts" "armadasScriptsRoot"
	local root = substituteString tmpRoot "\\" "/"
	
-- 	local favAr = #()
	
-- 	local root = modeArchiScriptRoot
-- 	local scriptArray = #()
	local scriptArray = #( "planificator\create_Plane_UI.ms", \
		"XformInPlace.ms", \
		"extractFaces2.ms", \
		"extractFaces.ms", \
		"plan_opacity.ms", \
		"rotater.ms", \
		"UvwSquare.ms", \
		"misc.ms", \
		"Rembarde_copieur\RembardeCopierUI.ms" , \
		"Rembarde_copieur\PoteauCreatorCoin.ms" , \
		"edgeToSweep.ms" , \
		"bardageCreator\zinc_creatorv2.ms", \
		"grid_manager.ms", \
-- 		"demultiMat.ms", \
		"Plan_resizer.ms")
	
	local fileClassArray = #()
	local displayAr = #()
		
	-- functions
	fn loadFavorites =
	(
		local favScriptArray = #()
		local favAr = #()
		
		-- load favorite list from ini file
		if (hasINISetting armadasScriptsIni "armadasScriptsFavorite" "armadasScriptsArray") == true then
		(
			print "ini key found"
			favArStr = getINISetting armadasScriptsIni  "armadasScriptsFavorite" "armadasScriptsArray"
			favArTmp = execute favArStr
-- 			print favArTmp
			-- test if file exist
			for onePath in favArTmp do
			(
				if doesFileExist onePath == true do
				(
					appendifunique favAr onePath
				)
			)
			
			-- correct file string
-- 			print favAr.count
			print "favorites list loaded."
		)
		else
		(
			favAr = #()
			print "favorites array init"
		)
-- 		
-- 		print favAr.count
		
		-- collect good scripts as favFileClass instance
		if favAr.count >= 1 then
		(
			
			favScriptArray = for script in favAr collect (favFileClass script)
		)
		else 
		(
			print "no favorites to load"
		)
		
		qsort favScriptArray sortbyname
		favScriptArray
	)
	
	fn loadCore =
	(
-- 		convert script selection 
		coreScriptArray = #()
		coreScriptArray = for script in scriptArray collect (favFileClass (root + "\\" + "zz_mode_archi" + "\\" +  script))
		coreScriptArray
	)
	
	fn writeFavorite =
	(
-- 		print "bye, favorites writting soon!"
		scriptsPathesAr  = for script in fileClassArray collect script.path
-- 		print scriptsPathesAr
		-- for each fav instance collect path
		-- write pathes in array
		data = with printAllElements on scriptsPathesAr as string
		test = setINISetting armadasScriptsIni "armadasScriptsFavorite" "armadasScriptsArray" data
		print "favorites list updated."
	)
	
-- 	UI
	button loadFavoritesBT "load favorites" across: 3
	button loadHardCoresBT "load core"
	button sortListBT  "sort by name"
		
	listbox scriptArrayLB "scripts list:"  height: 30
	
	/*
	button launchBT "launch"  pos:[10,btnLine1]
	button editBT "edit"  pos:[70,btnLine1]
	button openFolder "open scripts folder"  pos:[120,btnLine1]
	*/
	button launchBT "launch"  across: 3
	button editBT "edit"  
	button openFolder "open scripts folder" 
	button deleteBT "delete"
	
--  ui functions relative
	fn refreshList =
	(
		scriptArrayLB.items = for script in displayAr collect script.name
	)
	
-- 	actions

	on mxsLaunchRLT open do
	(
		fileClassArray = loadFavorites()
		displayAr = fileClassArray
		refreshList()
	)
	
	on loadFavoritesBT pressed do
	(
		fileClassArray = loadFavorites()
		displayAr = fileClassArray
		refreshList()

	)
	
	on loadHardCoresBT pressed do
	(
		fileClassArray = loadCore()
		displayAr = fileClassArray
		refreshList()
	)
	
	
	on sortListBT pressed do
	(
		qsort displayAr sortbyname
		refreshList()
	)
	
	on launchBT pressed do filein (fileClassArray[scriptArrayLB.selection].path)
	
	on scriptArrayLB doubleClicked  arg do
	(
		displayAr[arg].launch()
	)
	
	on editBT pressed do edit (fileClassArray[scriptArrayLB.selection].path)
		
	on openFolder pressed do 
	(
		foldToOpen = substituteString root "/" "\\"
-- 		print root
		doscommand ("explorer " + foldToOpen)
	)
	
	on deleteBT pressed do
	(
		id = scriptArrayLB.selection
		-- find selection in original array
		res = finditem fileClassArray displayAr[id] 
		
		-- delete selection
		test = deleteItem fileClassArray res
		-- write array list in ini
		
		writeFavorite()
		
		-- reload list
		
		fileClassArray = loadFavorites()
		displayAr = fileClassArray
		refreshList()
	)
	
	/*
	on mxsLaunchRLT resized size do
	(
		btnLine1 = mxsLaunchRLT.height - 30
		launchBT.pos = [10,btnLine1]
		editBT.pos = [70,btnLine1]
		openFolder.pos = [120,btnLine1]
		
		scriptArrayLB.height = mxsLaunchRLT.height - 80
	)
	*/
	
	on mxsLaunchRLT close do
	(
		writeFavorite()
	)
)
createdialog mxsLaunchRLT width:300 style: #(#style_titlebar, #style_border, #style_sysmenu,#style_minimizebox, #style_maximizebox )



/*
fn checkIniFileFn = 
(
	global modeArchiScriptRoot

	-- test init file
	maxIni = getMAXIniFile()
	rootTest = getINISetting maxIni "modeArchiScript" "root"
	
	if rootTest.count == 0 then
	(
		-- get root path
		modeArchiScriptRoot = getFilenamePath  (getThisScriptFilename() )
		-- write init
		setINISetting maxIni "modeArchiScript" "modeArchiScriptRoot" modeArchiScriptRoot
	)
	else
	(
		-- set modeArchiScriptRoot
		modeArchiScriptRoot = rootTest
	)
	return modeArchiScriptRoot
)
*/

-- maxIni = getMAXIniFile()
