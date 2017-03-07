-- maj:
	-- 	add refresh scene materials
	-- add split edge
	-- 
fn convertMultiMat =
(
	multi = meditmaterials[activeMeditSlot]

	for i = 1 to multi.count do
	(
		if classof multi[i] == standard then
		(
			colref = multi[i].diffuse
			newMat = VRayMtl diffuse: colref name: multi[i].name
			multi[i] = newMat
		)
	)
)
-- convertMultiMat()

fn tagMtlName tag=
(
	for m in scenematerials do
	(
		format "mat: %\n" m.name
		m.name =  tag + m.name
		format "mat: %\n" m.name
	)
)
-- tagMtlName "MATLOT_"

fn randomColorFN sel =
(
	randomColor = color (random 0 255) (random 0 255) (random 0 255)
	sel.wirecolor =  randomColor
)


fn randomWireFN useFirstId: true =
(
	for mat in sceneMaterials do 
	(
		randomWire = color (random 0 255) (random 0 255) (random 0 255) 
		sel = objects as array
		for o in sel do 
		(
			if (superclassof o == GeometryClass) do 
			(
				if (classof o.material) == multimaterial and useFirstId == true then
				(
-- 					print mat 
-- 					print o
					if o.material[1] == mat  do o.wirecolor = randomWire
				)
				else if  o.material == mat then
				(
					o.wirecolor = randomWire
				)
			)
		)
	)
)


-- make unique instance material
fn InstanceMatByName mat = (
	(for o in objects where o.mat != undefined and o.mat.name == mat.name collect o).mat = mat
)
 
--example usage:
-- InstanceMatByName (meditMaterials[1])


-- collect id materials as array
fn idArrayDef s =
(
	local idArray = #()
	local faceMax = s.GetNumFaces ()
	for i = 1 to faceMax do
	(
-- 		s.editablePoly.setSelection #face #{i}
		append idArray (s.editablePoly.GetFaceMaterial i)
	)
	return (sort(makeuniquearray idArray ))
)


-- explode mulitmat
fn explodeMultiMatDef s matchMat: false=
(
	local idArray = idArrayDef s
	local multiMtl = s.material 
	
	for id in idArray do
	(
		if id != 1 do
		(
			countBefore = objects.count
			s.selectByMaterial  id
			newName = uniquename (s.name + "_mat_" + (id as string))
			polyop.detachFaces s #selection delete: true asNode: true name: newName
			
			if matchMat then
			(
				res = getnodebyname newName
				res.material = multiMtl[id]
				format "obj: %, \tmat: % \n" res.name multiMtl[id]
			)
			
			
			-- copy/paste original modifier
			contAfter = objects.count
-- 			format "count"
			mf = for m in  s.modifiers collect m
			for i = (countBefore + 1) to objects.count do
			(
-- 				format "i :%\n" i
-- 				format "obj explode:%\n" objects[i]
				for m in s.modifiers do addmodifier objects[i] m
			)
			
		)
	)
	
	if matchMat then s.material = multiMtl[idArray[1]]
	format "explode material done: %\n" s
)

-- explodeMultiMatDef $ matchMat: true
-- select objects[objects.count]
-- mf = for m in  s.modifiers collect m

-- addmodifier w



-- collect scene multimaterial
fn collectMultiMatDef =
(
	-- collect mulimaterial in material editor
	multimatArray = #()
	for mat in sceneMaterials do 
		if (classof mat) == Multimaterial do
		(
			append  multimatArray mat
		)
	 print 	multimatArray

	for i = 1 to multimatArray.count do
	(meditMaterials[i] = multimatArray[i])
)

-- refresh scenematerial
fn updateSceneMaterials =
 (
-- 	 saveNodes #() "d:/temp.max"
-- 	 deleteFile "d:/temp.max"
	saveNodes #() "j:/temp.max"
	 deleteFile "j:/temp.max"
 )
-- updateSceneMaterials()

fn skinMultiMatdef s =
(
-- for one object
	-- count multimaterial number

	
	multiTmp = s.material.count
	
	-- count objet id
	idMax = 0
	faceMax = s.GetNumFaces ()
	for i = 1 to faceMax do
	(
		polyop.setFaceSelection s i
		if (s.getMaterialIndex true) > idMax do idMax = s.getMaterialIndex true
	)
	polyop.setFaceSelection s #none
	print idMax
	
	tmpMat
	-- pour chaque id de l'objet a partir de 2:
	for i = 2 to idMax do
	(
		tmpMat = s.material
		-- detach faces with one material
		s.selectByMaterial  i
		newName = uniquename (s.name + "_mat_" + (i as string))
		polyop.detachFaces s #selection delete: false asNode: true name: newName
		
		newSkin = getnodebyname newName
		
		-- option: split edge by smoothing group
		-- appliquer un shell sur le nouvel objet
		-- faire un outline sur l'objet
		-- rename object by material
		-- apply unique matching material
		newSkin.material = tmpMat[i]
	)
	
-- 	s.material = tmpMat[1]
)
				

fn createVrMtl =
(
	meditMaterials[activeMeditSlot] = vraymtl()
)

/*
fn collectSelMtl =
(
	sel = selection as array
	for s in sel do print s
-- 	if sel.count > 0 then
-- 	(
-- 		meditMaterials[activeMeditSlot] = sel[1].material
-- 	)
)
-- collectSelMtl()
*/

fn createTile =
(
	meditMaterials[activeMeditSlot] = bricks()
)

-- remove materiel
fn removeMatDef =
(
	$.material = undefined
)


/*
-- replace by instance
sel = selection as array 
instanceReplace sel (sphere())
*/



fn publishSceneMatDef vrOnly: true  maxMatNum: 0 =
(
	local matToPubAr = #()

	-- collect scene material in array
	for i = 1 to sceneMaterials.count do
	(
		tmpMat = sceneMaterials[i]
		if classof tmpMat == vraymtl and vrOnly == true do
		(
			continue
		)
		append matToPubAr tmpMat
	)
	
	-- publich materials in material editor
	lastMatNum = maxMatNum + 24
	print (format "min: %, max: %\n" maxMatNum lastMatNum)
	
	if  matToPubAr.count  <= lastMatNum do
	(
		lastMatNum = matToPubAr.count 
	)
	
	for i =  1 to 24 do
	(
		if matToPubAr[i + maxMatNum] != undefined then
		(
			meditMaterials[i] = matToPubAr[i + maxMatNum]
		)
		else
		(
			meditMaterials[i] = standard()
		)
	)
	
	#(sceneMaterials.count, lastMatNum)
)

-- convert standard to vray
fn convertToVrMatDef =
(
	vrMat = VRayMtl diffuse: meditMaterials[activeMeditSlot].diffuse name: meditMaterials[activeMeditSlot].name
	replaceinstances meditMaterials[activeMeditSlot] vrMat
)

-- meditMaterials[activeMeditSlot].diffuse

/*
fn publishSceneMatAdvDef =
(
	allMatAr = for mat in sceneMaterials collect mat

	lastMatNum = 0

	for i = 1 to 24 do
	(
		if ((i + lastMatNum) <  allMatAr.count) then
		(
			if (classof  allMatAr[i+lastMatNum]) != vraymtl do
			(
				meditMaterials[i] = allMatAr[i+lastMatNum]
			)
		)
		else
		(
			lastMatNum = 0
			break
		)
	)
	lastMatNum +=24
)
*/
-- function to return good smooth grp id
fn convertToSmoothGrpDef num =
(
	if num == 1 then
	(
		return 1
	)
	else
	(
		return (num^0.5 + 1)
	)
)

fn splitSmthGrpDef s =
(
	facesCount = s.editablepoly.ConvertSelection #object #Face

	smoothGroupAr = #()
	for i = 1 to facesCount do
	(
		smoothGroupId = s.editablepoly.GetFaceSmoothingGroups i
	-- 	print smoothGroupId
		append smoothGroupAr  smoothGroupId
	-- 	smoothGroupAr = makeuniquearray smoothGroupAr
	)
	smoothGroupAr = makeuniquearray smoothGroupAr
	print smoothGroupAr

	for o in smoothGroupAr do
	(
		smthGrp = convertToSmoothGrpDef o
		s.editablepoly.selectBySmoothGroup smthGrp
		s.editablepoly.ConvertSelectionToBorder #face #edge
		s.editablepoly.splitEdges()
		
	)
)
-- splitSmthGrpDef $

fn collectMatFromSel sel=
(
	matAr = #()
-- 	for s in sel do print s
	for s in sel where s.material != undefined do appendifunique matAr s.material 
	if matAr.count < 25 then
	(
		for i = 1 to matAr.count do meditMaterials[i] = matAr[i]
	)
	else
	(
		for i = 1 to 24 do meditMaterials[i] = matAr[i]
	)
)


try(destroyDialog deMultiMatRLT)catch()

rollout deMultiMatRLT "Materials utilities"
(
	local lastManNum = 0
	
	
	group "wirecolor: "
	(
		button randColBT "random color"
		checkbox multiMatIDCB "use first id for multimaterial" checked: true
		button randomWireBT "wirecolor by material"
	)
	
	group "Multi-Materials:"
	(
		button collectMultiBT "collect multi-materials"
		button skinMatBT "skin multi-materials"
		button removeMatBT "remove material"
		button splitEdgeBT "split edges"
		
	)
	
	group "explode multi-Materials:"
	(
		checkbox matchMatCB "match materials"
		button explodeBT "explode by material"
	)
	
	group "scene Materials:"
	(
		button refreshBT "refresh scene materials"
		checkbox vronlyCB "except vray materials"
		button publishSceneMatBT "publish scene materials"
-- 		button publishSceneMat2BT "publish scene materials adv"
	)
	
	group "material"
	(
		button createVrMtlBT "create vray material"
-- 		button collectVrMtlBT "collect material"
-- 		button createTileBT "create tile"
	)
	
	group "selection  material"
	(
		button collectSelMatBT "collect selection material"

	)
	
	group "V-Ray:"
	(
		button convertToVrBT "convert to vray mat"
	)
	
	
	on randColBT pressed do
	(
		for s in selection do randomColorFN s
	)
	
	on randomWireBT pressed do
	(
		randomWireFN useFirstId: multiMatIDCB.state
	)
	
	on collectMultiBT pressed do collectMultiMatDef()
	
	on collectSelMatBT pressed do
	(
		print "youpi"
		sel = selection as array
		collectMatFromSel sel
	)
	
	on explodeBT pressed do 
	(
		sel = selection as array
		
-- 		if sel.count == 1 do 
-- 		(
			for s in sel where classof s.material == multimaterial do
			(
				explodeMultiMatDef s  matchMat: matchMatCB.state
			)
-- 		)
	)
	
	on skinMatBT pressed do 
	(
		sel = selection as array
		for s in sel do
		(
			if (classof s.material) == multimaterial do
			(
				undo on
				(
					skinMultiMatdef s
				)
			)
		)
	)
	
	on splitEdgeBT pressed do
	(
		sel = selection as array
		
		for s in sel do
		(
			undo on
			(
				splitSmthGrpDef s
			)
		)
	)
	
	on removeMatBT pressed do removeMatDef()
	
	on  refreshBT pressed do 
	(
		lastManNum = 0
		updateSceneMaterials()
	)

	on publishSceneMatBT pressed do
	(
-- 		print "youhou"
		compare = publishSceneMatDef vronly: vronlyCB.state maxMatNum: lastManNum
		sceneCount = compare[1]
		lastManNum = compare[2]
		if  lastManNum >= sceneCount then lastManNum = 0
		
-- 		print (format "compare : %\n" compare)
	)
		
	on convertToVrBT pressed do convertToVrMatDef()
	on publishSceneMat2BT pressed do publishSceneMatAdvDef()
	
	on createVrMtlBT pressed do createVrMtl()
-- 	
-- 	on collectVrMtlBT pressed do 
-- 	(
-- 		print "start collect"
-- 		sel = selection as array
-- 		collectMatFromSel sel
-- 	)
	
	on createTileBT pressed do createTile()
	
)
createdialog deMultiMatRLT


sel = selection as array
withoutMatAr = for s in sel where s.material == undefined and superclassof s == GeometryClass collect s
select withoutMatAr

