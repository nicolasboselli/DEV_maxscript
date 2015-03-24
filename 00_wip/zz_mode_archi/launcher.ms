/*
maj: make install file with:
	- ini near of 3dsmax.ini
	- fonction to return script root from ini. paste in macro script or startup?
	- command to install lancher in 3dsmax ui
*/
-- subrollout or roller floater that is the question

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


-- maj:
-- remove favorite

struct fileClass
(
	path,
	name = getFilenameFile path
)


rollout mxsLaunchRLT "maxscript launcher"
(
-- 	local var = checkIniFileFn()
	local btnLine1 = 180
	
	local maxIni = getMAXIniFile()
	local armadasScriptsIni = (getFilenamePath maxIni) + "armadasScriptsIni.ini"
	
	local root = getINISetting armadasScriptsIni "armadasScripts" "armadasScriptsRoot"
	
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
		
	listbox scriptArrayLB "scripts list:" 
	
	button launchBT "launch"  pos:[10,btnLine1]
	button editBT "edit"  pos:[70,btnLine1]
	button openFolder "open scripts folder"  pos:[120,btnLine1]
	
-- 	actions
	on launchBT pressed do filein (fileClassArray[scriptArrayLB.selection].path)
-- 	on editBT pressed do edit (root + "\\zz_mode_archi\\"  + scriptArrayLB.selected)
	on editBT pressed do edit (fileClassArray[scriptArrayLB.selection].path)
		
	on openFolder pressed do 
	(
		
		var = stringstream ""
		format "explorer %" root to: var
		doscommand (var as string)
	)
	
	on loadFavoritesBT pressed do
	(
		-- load favorite list from ini file
		if (hasINISetting armadasScriptsIni "armadasScripts" "armadasScriptsRoot") == true then
		(
			favArTmp = getINISetting armadasScriptsIni  "armadasScriptsFavorite" "armadasScriptsArray"
			favAr = execute favArTmp
			print favAr
			print "load favorites done"
		)
		else
		(
			favAr = #()
			print "favorites array init"
		)
		
		fileClassArray = for script in favAr collect (fileClass script)
		scriptArrayLB.items = for script in fileClassArray collect script.name
	)
	
	on loadHardCoresBT pressed do
	(
		-- 		convert script selection 
		fileClassArray = for script in scriptArray collect (fileClass (root + "\\zz_mode_archi\\" +  script))
-- 		collect list box items
		scriptArrayLB.items = for script in fileClassArray collect script.name
		
	)
	
	on mxsLaunchRLT open do
	(

		
-- 		convert script selection 
		fileClassArray = for script in scriptArray collect (fileClass (root + "\\zz_mode_archi\\" +  script))
		
-- 		collect list box items
		scriptArrayLB.items = for script in fileClassArray collect script.name
	)
	
	on mxsLaunchRLT resized size do
	(
		btnLine1 = mxsLaunchRLT.height - 30
		launchBT.pos = [10,btnLine1]
		editBT.pos = [70,btnLine1]
		openFolder.pos = [120,btnLine1]
		
		scriptArrayLB.height = mxsLaunchRLT.height - 80
	)

)
createdialog mxsLaunchRLT width:300 style: #(#style_resizing,#style_titlebar, #style_border, #style_sysmenu,#style_minimizebox, #style_maximizebox )

