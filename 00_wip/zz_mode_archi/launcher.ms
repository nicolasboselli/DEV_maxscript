/*
maj: make install file with:
	- ini near of 3dsmax.ini
	- fonction to return script root from ini. paste in macro script or startup?
	- command to install lancher in 3dsmax ui
*/


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
		"Plan_resizer.ms")
	
	
	
	listbox scriptArrayLB "scripts list:" items: scriptArray
	
	button launchBT "launch" across: 2
	button editBT "edit"
	
	on launchBT pressed do filein (root + scriptArrayLB.selected)
	on editBT pressed do edit (root + scriptArrayLB.selected)

)
createdialog mxsLaunchRLT width:300 style: #(#style_resizing,#style_titlebar, #style_border, #style_sysmenu,#style_minimizebox, #style_maximizebox )
