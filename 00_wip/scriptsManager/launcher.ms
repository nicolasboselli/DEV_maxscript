/*
-- maj:
-- remove favorite
-- catch obsolete path
-- add cleaner at opening and update on closing
*/

-- with printAllElements on propArVal as string

try(destroyDialog mxsLaunchRLT)catch()

struct favFileClass
(
	path,
	name = getFilenameFile path
)


rollout mxsLaunchRLT "maxscript launcher"
(
-- 	local var = checkIniFileFn()
	local btnLine1 = 450
	
	local maxIni = getMAXIniFile()
	local armadasScriptsIni = (getFilenamePath maxIni) + "armadasScriptsIni.ini"
	
	local tmpRoot = getINISetting armadasScriptsIni "armadasScripts" "armadasScriptsRoot"
	local root = substituteString tmpRoot "\\" "/"
	
	local favAr = #()
	
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
	
-- 	UI
	button loadFavoritesBT "load favorites" across: 2
	button loadHardCoresBT "load core"
		
	listbox scriptArrayLB "scripts list:"  height: 30
	
	button launchBT "launch"  pos:[10,btnLine1]
	button editBT "edit"  pos:[70,btnLine1]
	button openFolder "open scripts folder"  pos:[120,btnLine1]
	
--  ui functions relative
	fn loadCore =
	(
		
-- 		convert script selection 
		fileClassArray = for script in scriptArray collect (favFileClass (root + "\\" + "zz_mode_archi" + "\\" +  script))
		
-- 		collect list box items
		scriptArrayLB.items = for script in fileClassArray collect script.name
		
	)
	
	fn loadFavorites =
	(
		
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
			print "load favorites done"
		)
		else
		(
			favAr = #()
			print "favorites array init"
		)
		
		print favAr.count
		if favAr.count >= 1 then
		(
			fileClassArray = for script in favAr collect (favFileClass script)
			scriptArrayLB.items = for script in fileClassArray collect script.name
		)
		else
		(
			print "no favorites to load"
		)
	)
		
	
-- 	actions

	on mxsLaunchRLT open do loadFavorites()
	
	on loadFavoritesBT pressed do loadFavorites()
	
	on loadHardCoresBT pressed do loadCore()
	
	
	on launchBT pressed do filein (fileClassArray[scriptArrayLB.selection].path)
	on editBT pressed do edit (fileClassArray[scriptArrayLB.selection].path)
		
	on openFolder pressed do 
	(
		foldToOpen = substituteString root "/" "\\"
-- 		print root
		doscommand ("explorer " + foldToOpen)
	)
	
	
	
	on mxsLaunchRLT resized size do
	(
		btnLine1 = mxsLaunchRLT.height - 30
		launchBT.pos = [10,btnLine1]
		editBT.pos = [70,btnLine1]
		openFolder.pos = [120,btnLine1]
		
		scriptArrayLB.height = mxsLaunchRLT.height - 80
	)
	
	on mxsLaunchRLT close do
	(
		print "bye"
	)
)
createdialog mxsLaunchRLT width:300 style: #(#style_resizing,#style_titlebar, #style_border, #style_sysmenu,#style_minimizebox, #style_maximizebox )



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
