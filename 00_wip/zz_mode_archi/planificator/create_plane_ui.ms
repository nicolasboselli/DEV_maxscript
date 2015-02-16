/*
maj:
xre open the selected folder
display only jpg name
add scaler on new plan
x make plane backface display
move plane on plan layer
x save last folder as ini file
xselect plane after creation

function to extract part of a plan
	- detach poly
	- copy uvwap
	- add scaler

*/


rollout createPlaneRLT "create plane"
(
	local openFileName
	local root = "C:\\"
	local jpgList = #()
	local jpgSel
	
	label pathLab "path :" across: 3
	edittext pathToSearchET readOnly: true
	button searchBT "..."
	listbox jpgListBox "jpg list:"
	button createPlaneBT "create" across:3
	button injectMapBT "inject"
	button changeMapBT "change map"
	
	
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
	
-- 	create plane and add plan material
	fn createMappedPlane oneJpg = 
	(
	-- 	create plane
		tmpPlane = Plane length:1000 width:800 pos:[0,0,0]  lengthsegs: 1 widthsegs: 1 name: ((filenameFromPath oneJpg) + "_plane") \
		backfacecull: on renderable: off
	-- 	createMap
		jpgMap = Bitmaptexture fileName: oneJpg
	-- 	create material
		tmpMaterial = Standardmaterial name: ((filenameFromPath oneJpg) + "mat")
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
		onePlane.name = (filenameFromPath oneJpg) 
		
		jpgMap = Bitmaptexture fileName: oneJpg
	-- 	create material
		tmpMaterial = Standardmaterial name: ((filenameFromPath oneJpg) + "mat")
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
			jpgListBox.items = jpgList
		)
	)
	
	on createPlaneBT pressed do
	(
		jpgSel = jpgListBox.selected
		
		mapPlane = createMappedPlane jpgSel
		ajustUVWmap mapPlane
		
		lay = createPlansLayerFN()
		lay.addnode mapPlane
		
		select mapPlane
	)
	
	on injectMapBT pressed do
	(
		sel = $selection as array
		if sel.count == 1 then
		(
			deleteUVWmap sel[1]
			
			jpgSel = jpgListBox.selected

			mapPlane = reMapPlane sel[1] jpgSel
			ajustUVWmap mapPlane
		)
	)
	
	on changeMapBT pressed do
	(
		sel = $selection as array
		if sel.count == 1 then
		(
			jpgSel = jpgListBox.selected
			
			mapPlane = reMapPlane sel[1] jpgSel
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
			jpgListBox.items = jpgList
			
		)
	)
	
	on createPlaneRLT close do
	(
		-- maj ini file
		root = setINISetting (modeArchiScriptRoot + "scriptMode.ini") "planCreator" "jpgPath" root
		print "maj ini done"
	)
)
createDialog createPlaneRLT width: 500 #(#style_resizing,#style_titlebar, #style_border, #style_sysmenu,#style_minimizebox, #style_maximizebox )


