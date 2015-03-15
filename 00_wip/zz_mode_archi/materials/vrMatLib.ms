
-- base material grid
fn createGridBaseMatFN =
(
	local gridmap = bricks Tile_Type: 5 Lock_Gap_Symmetry: 0 Fade_Variance: 0 Brick_Color: (color 0 0 0) Mortar_Color: (color 255 255 255) \
	Vertical_Count: 1 Vertical_Gap: 0 Horizontal_Gap: 2

	local gridMat = standard name: "gc_grid_material" twoSided: true Diffuse: (color 0 0 0 ) opacityMap: gridmap
)

-- vr material enduit
fn createEnduitVRMatFN = 
(
	local enduitMat = vraymtl name: "enduit_blanc" diffuse: (color 235 235 235)
)

-- vr material enduit
fn createConcreteVRMatFN = 
(
	local enduitMat = vraymtl name: "beton_blanc" diffuse: (color 235 235 235)
)


fn createVrayMatFN matName = 
(
	if matName == "gc_grid_material" then return createGridBaseMatFN()
	else if matName == "enduit_blanc" then return createEnduitVRMatFN()
	else if matName == "beton_blanc" then return createConcreteVRMatFN()
	else print "no material definition"
)

-- rollout
rollout vrMatRlt "VRay mat Lib"
(
	local matList = #("gc_grid_material", "enduit_blanc", "beton_blanc")
	
	listbox matLB "materials list:" items: matList
	
	button creatMatBT "create material"
	
	button gridBaseMatBT "Grid Material"
	button enduitVRMatBT "Enduit Material"
	button betonblancVRMatBT "beton blanc"
	
	on creatMatBT pressed do
	(
		matName = matLB.selected
		tmpMat = createVrayMatFN matName
		res = scenematerials[tmpMat.name]
		
		if res == undefined then
		(
			meditMaterials[activeMeditSlot] = tmpMat
		)
		else
		(
			
			meditMaterials[activeMeditSlot] = res
		)
	)
	
)
createdialog vrMatRlt