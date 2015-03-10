/*
maj:

display only jpg name
check plan already in scene and display with "*" in the list
add button  to open plan folder
add button to view plan in xnview
add button to select plan in scene

add scaler on new plan



function to extract part of a plan
	- detach poly
	- copy uvwap
	- add scaler

*/



 
 
struct planClass
(
	path,

	fn checkinscene  =
	(
		local inscene = False
		for mat in scenematerials do 
		(
			bitMapFile = undefined
			try
			(
				bitMapFile = mat.diffuseMap.bitmap.filename
			)
			catch
			(
				bitMapFile = undefined
			)
			
			if bitMapFile != undefined do
			(
				if bitMapFile == path do
				(
					inscene =  true
					break
				)
			)
		)
		return inscene
	),
		
	inscene = checkinscene(),
	
	fn checkname =
	(
		local basename = getFilenameFile path
		if inscene == true then
		(
			return ("_______LOADED____" + basename )
		)
		else
		(
			return basename
		)
	),

	name = checkname()
	
)


 
rollout createPlaneRLT "create plane"
(
	local openFileName
	local root = "C:\\"
	local jpgList = #()
	local jpgSel
	
	local lastLine = 220
	
	local planObjList = #()
	
	edittext pathToSearchET"path: "readOnly: true
	button searchBT "..."
	listbox jpgListBox "jpg list:"
	
	button createPlaneBT "create"  pos:[ 50 , lastLine]
	button injectMapBT "inject" pos:[150,lastLine]
	button changeMapBT "change map" pos:[250,lastLine]
	
	fn createPlansLayerFN =
	(
		local LM = layermanager
		local planLayer
		if (LM.getLayerFromName "plans") == undefined then
		(
			planLayer = LM.newLayerFromName "plans"
		)
		else
		(
			planLayer = LM.getLayerFromName "plans"
		)
		return planLayer
	)
	
	
	fn returnJpgList oneJpg =
	(
		jpgDir = getFilenamePath  oneJpg
		jpgListTmp = getFiles (jpgDir + "*.jpg")

		return jpgListTmp
	)
	
	fn initPlanClass jpgList =
	(
		planObjList = for oneJpg in jpgList collect (planClass oneJpg)
		print planObjList
		return planObjList
	)
	
-- 	create plane and add plan material
	fn createMappedPlane oneJpg = 
	(
	-- 	create plane
		tmpPlane = Plane length:1000 width:800 pos:[0,0,0]  lengthsegs: 1 widthsegs: 1 name: ("plane_" + (getFilenameFile oneJpg)) \
		backfacecull: on renderable: off
	-- 	createMap
		jpgMap = Bitmaptexture fileName: oneJpg name: ("zz_map_" + (getFilenameFile oneJpg))
	-- 	create material
		tmpMaterial = Standardmaterial name: ("zz_plan_" + (getFilenameFile oneJpg))
		tmpMaterial.diffuseMap = jpgMap
		tmpMaterial.showInViewport =on
		-- 	assign material on plane
		tmpPlane.material = tmpMaterial
		return tmpPlane
	)
	
-- 	delete uvwmap
	fn deleteUVWmap onePlane =
	(
		for i = onePlane.modifiers.count to 1 by -1 do
		(
			if ((classOf onePlane.modifiers[i]) == Uvwmap) do
			(
				deleteModifier onePlane i
			)
		)
	)
	
-- 	rename plane and add plane material
	fn reMapPlane onePlane oneJpg= 
	( 
		onePlane.name = ("plane_" + (getFilenameFile oneJpg)) 
		
		jpgMap = Bitmaptexture fileName: oneJpg name: ("zz_map_" + (getFilenameFile oneJpg))
	-- 	create material
		tmpMaterial = Standardmaterial name: ("zz_plan_" +(getFilenameFile oneJpg))
		tmpMaterial.diffuseMap = jpgMap
		tmpMaterial.showInViewport =on
		-- 	assign material on plane
		onePlane.material = tmpMaterial
		return onePlane
	)

	
	fn ajustUVWmap onePlane= 
	(
		myUV = Uvwmap()
		myUV.length = onePlane.length
		myUv.width = onePlane.width

		addmodifier onePlane myUV	 
		
		myBitmap = onePlane.material.diffusemap.bitmap
		
		bitHeight = myBitmap.height
		bitWidth = myBitmap.width

		UVlength = myUV.length

		myUV.width = (UVlength*bitWidth)/bitHeight
	)
	
-- 	collect jpg
	on searchBt pressed do
	(
		openFileName = getOpenFileName caption: "test" filename:root types: "jpg(*.jpg)|*.jpg|All Files|*.*"
		
		if openFileName != undefined then
		(
			root = getFilenamePath openFileName
			
			pathToSearchET.text = root
			jpgList = returnJpgList openFileName
			planObjList = initPlanClass jpgList
			
			
			jpgListBox.items = for jpg in planObjList collect jpg.name
		)
	)
	
	on createPlaneBT pressed do
	(
		intSel = jpgListBox.selection 
		jpgSel = planObjList[intSel]
		
		mapPlane = createMappedPlane jpgSel.path
		ajustUVWmap mapPlane
		
		lay = createPlansLayerFN()
		lay.addnode mapPlane
		
		-- update listbox
		planObjList = initPlanClass jpgList
		jpgListBox.items = for jpg in planObjList collect jpg.name
		
		select mapPlane
	)
	
	on injectMapBT pressed do
	(
		sel = $selection as array
		if sel.count == 1 then
		(
			deleteUVWmap sel[1]
			
			intSel = jpgListBox.selection 
			jpgSel = planObjList[intSel]

			mapPlane = reMapPlane sel[1] jpgSel.path
			ajustUVWmap mapPlane
			
			-- update listbox
			planObjList = initPlanClass jpgList
			jpgListBox.items = for jpg in planObjList collect jpg.name
		)
	)
	
	on changeMapBT pressed do
	(
		sel = $selection as array
		if sel.count == 1 then
		(
			intSel = jpgListBox.selection 
			jpgSel = planObjList[intSel]
			
			mapPlane = reMapPlane sel[1] jpgSel.path
-- 			ajustUVWmap mapPlane
		)
	)
	
	on createPlaneRLT open do
	(
		-- load ini file
		rootIni = getINISetting (modeArchiScriptRoot + "scriptMode.ini") "planCreator" "jpgPath"
		if rootIni != undefined and rootIni != "C:\\" do 
		(
			root = rootIni
			
			pathToSearchET.text = root
			jpgList = getFiles (root + "*.jpg")
			planObjList = initPlanClass jpgList
			
			jpgListBox.items = for jpg in planObjList collect jpg.name
			
		)
	)
	
	on createPlaneRLT close do
	(
		-- maj ini file
		root = setINISetting (modeArchiScriptRoot + "scriptMode.ini") "planCreator" "jpgPath" root
		print "maj ini done"
	)
	
	on createPlaneRLT resized size do
	(
		local sub = 30
		jpgListBox.height = createPlaneRLT.height - 120
		createPlaneBT.pos = [ 50, createPlaneRLT.height - sub]
		injectMapBT.pos = [150, createPlaneRLT.height - sub]
		changeMapBT.pos = [250, createPlaneRLT.height - sub]
	)
)
createDialog createPlaneRLT width: 500 style: #(#style_resizing,#style_titlebar, #style_border, #style_sysmenu,#style_minimizebox, #style_maximizebox )

