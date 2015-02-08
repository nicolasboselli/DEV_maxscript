/*
maj:
re open the selected folder
display only jpg name
add scaler on new plan
make plane backface display
move plane on plan layer
save last folder as global varand load it on reopen
select plane after creation
function to extract part of a plan
	- detach poly
	- copy uvwap
	- add scaler

*/


rollout createPlaneRLT "create plane"
(
	local openFileName
	local root = "J:\\_svn"
	local jpgList = #()
	local jpgSel
	
	label pathLab "path :" across: 3
	edittext pathToSearchET readOnly: true
	button searchBT "..."
	listbox jpgListBox "jpg list:"
	button createPlaneBT "create" across:3
	button injectMapBT "inject"
	button changeMapBT "change map"
	
	
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
		tmpPlane = Plane length:1000 width:800 pos:[0,0,0]  lengthsegs: 1 widthsegs: 1 name: ((filenameFromPath oneJpg) + "_plane")
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
		pathToSearchET.text = openFileName
		if openFileName != undefined then
		(
			jpgList = returnJpgList openFileName
			jpgListBox.items = jpgList
		)
	)
	
	on createPlaneBT pressed do
	(
		jpgSel = jpgListBox.selected
		
		mapPlane = createMappedPlane jpgSel
		ajustUVWmap mapPlane
		
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
		print "opening"
	)
	
	on createPlaneRLT close do
	(
		print "closing"
	)
)
createDialog createPlaneRLT width: 500



