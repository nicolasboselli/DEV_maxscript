/*
maj:
	-- synchronise material libray with scenematerial applied to objects
		-- from library to editor, like replace(isntance)
		-- from editor to library
		-- check name
		-- map when apply material edited to object
		-- auto re-map on opening when compare lib map with scene mat
		
	-- in library
		-- make same material with same property unique
		-- auto change name on material with same name
		
	-- versioning material file
*/


-- rollout
rollout vrMatRlt "VRay mat Lib"
(
	local vrLibPath =  "G:\vrlib.mat"
	local matList = #("gc_grid_material", "enduit_blanc", "beton_blanc")
	local openFileName
	local vrLibAr = #()
	local vrLib = materiallibrary()
	
-- 	UI
	group "library file:"
	(
-- 		button loadCoreBT "load core"
		edittext libPthBT "lib :" readonly: true
		button openLibBT "..." across: 3
		button saveLibBT "save"
		button saveAsLibBT "save as"
	)
	
	group "manage library:"
	(
		button addMatBT "add mat"
		button delMatBT "delete mat" enabled: false
		button upLibBT "refresh lib"
		listbox matLB "materials list:" --items: matList	
		button creatMatBT "edit material"
-- 		button replaceMatBT "replace material" enabled: false
	)
	
	group "map material:"
	(
		button mapLibToEdBT "library => editor"  enabled: false
		button mapEdToLibBT "editor => library"  enabled: false
	)
	
-- 	actions
	on vrMatRlt open do
	(
		vrLib = loadTempMaterialLibrary vrLibPath
		libPthBT.text = vrLibPath
		matLB.items = for mat in vrLib collect mat.name
	)
	
	on openLibBT pressed do
	(
		vrLibPath = getOpenFileName caption: "open material library" types: "mat(*.mat)|*.mat|All Files|*.*"
-- 		openFileName = fileOpenMatLib()
		print vrLibPath
		
		if vrLibPath != undefined do
		(
			vrLib = loadTempMaterialLibrary vrLibPath
			libPthBT.text = vrLibPath
			matLB.items = for mat in vrLib collect mat.name
		)
		print openFileName
	)
	
	on saveLibBT pressed do
	(
		saveTempMaterialLibrary  vrLib libPthBT.text
	)
	
	on saveAsLibBT pressed do
	(
		tmpPath = getSaveFileName caption: "save material library" types: "mat(*.mat)|*.mat|All Files|*.*"
		saveTempMaterialLibrary  vrLib tmpPath
	)
	
	on loadCoreBT pressed do
	(
		matLB.items = matList
	)

	
	on upLibBT pressed do
	(
-- 		tmpLib = materialLibrary
-- 		vrLib = loadTempMaterialLibrary vrLibPath
		matLB.items = for mat in vrLib collect mat.name
	)
	
	on addMatBT pressed do
	(
		append  vrLib meditMaterials[activeMeditSlot]
		matLB.items = for mat in vrLib collect mat.name
	)
	
	on creatMatBT pressed do
	(
		matName = matLB.selected
		
		tmpMat = vrlib[matName]
-- 		tmpMat = createVrayMatFN matName
		
		meditMaterials[activeMeditSlot] = tmpMat
		/*
		res = scenematerials[tmpMat.name]
		
		if res == undefined then
		(
			meditMaterials[activeMeditSlot] = tmpMat
		)
		else
		(
			
			meditMaterials[activeMeditSlot] = res
		)
		*/
	)
	
)
createdialog vrMatRlt

/*
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
*/

/*

vrLib =  materialLibrary()
append vrLib meditMaterials[activeMeditSlot]

for mat in vrLib do print mat
	
saveTempMaterialLibrary  vrLib "G:\vrlib.mat"

tmp =  materialLibrary()
tmp = loadTempMaterialLibrary "G:\vrlib.mat"

meditMaterials[activeMeditSlot] = vrLib[1]

*/


/*
maxIni = getMAXIniFile()
vrayLibIni = (getFilenamePath maxIni) + "vrayLib.ini"
setINISetting vrayLibIni "vrayLib" enduitMat.name  propArVal
	

test = createGridBaseMatFN()
show test.opacityMap


-- enduitMat = vraymtl()
enduitMat = meditMaterials[activeMeditSlot]

propAr = getPropNames  enduitMat
propArVal = for t in propAr collect (getProperty enduitMat t)
with printAllElements on propArVal as string



setINISetting vrayLibIni "vrayLib" enduitMat.name  (with printAllElements on propArVal as string)
vrString = getINISetting vrayLibIni "vrayLib" enduitMat.name
vrVal = execute vrString
*/
-- getProperty enduitMat #texmap_diffuse

-- getPropertyController enduitMat