/*
maj: make install file with:
	- ini near of 3dsmax.ini
	- fonction to return script root from ini. paste in macro script or startup?
	- command to install lancher in 3dsmax ui
*/
-- subrollout or roller floater that is the question

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


rollout mxsLaunchRLT "maxscript launcher"
(
	local var = checkIniFileFn()
	local btnLine1 = 180
	
	local root = modeArchiScriptRoot
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
	
	
	
	listbox scriptArrayLB "scripts list:" items: scriptArray
	
	button launchBT "launch"  pos:[10,btnLine1]
	button editBT "edit"  pos:[70,btnLine1]
	button openFolder "open scripts folder"  pos:[120,btnLine1]
	
	on launchBT pressed do filein (root + scriptArrayLB.selected)
	on editBT pressed do edit (root + scriptArrayLB.selected)
	on openFolder pressed do 
	(
		
		var = stringstream ""
		format "explorer %" modeArchiScriptRoot to: var
		doscommand (var as string)
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

