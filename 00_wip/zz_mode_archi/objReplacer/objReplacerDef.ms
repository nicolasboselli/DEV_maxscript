-- ref = selection as array

-- targets = selection as array

fn checkReferenceDef sel =
/*
function to sheck the selection. the selection must be unique with one ffd box modifer.
param: none
return: node
*/
(
	if (sel.count == 1) then
	(
		local correctFFD = False
		for modTmp in sel[1].modifiers do
		(
			if classof modTmp == FFD_2x2x2 do
			(
				correctFFD = true
				break
			)
		)
		if correctFFD == true then
		(
			return sel[1]
			print "selection conform"
		)
		else
		(
			print "your selection neeeds one ffd box"
			return undefined
		)

	)
	else if (sel.count > 1) then
	(
		local isgroup = False
		local tmpDummy
		
		for s in sel do 
			if (classof s == dummy) do 
			(
				tmpDummy = s
				isgroup = true
				break
			)
		
		if isgroup == true then
		(
			print "selection is a group" 
			return tmpDummy
		)
		else
		(
			return undefined
		)
	)
	
	else
	(
		print "select one object only."
		return undefined
	)
)




fn replaceRefDef ref tgt =
(
	modFFD

	infoStr = stringstream ""
	format "% replace %" ref tgt to: infoStr
	print(infoStr as string)
	
		-- collect x,y and z max on target
	vertNum = tgt.GetNumVertices ()
	maxX = -1000
	minX = 1000
	maxY = -1000
	minY = 1000
	maxZ = -1000
	minZ = 1000
	
	for i = 1 to vertNum do
	(
		posTmp = tgt.getvertex i
		
		if posTmp.x > maxX do maxX = posTmp.x
		if posTmp.x < minX do minX = posTmp.x
		if posTmp.y > maxY do maxY = posTmp.y
		if posTmp.y < minY do minY = posTmp.y
		if posTmp.z > maxZ do maxZ = posTmp.z
		if posTmp.z < minZ do minZ = posTmp.z
	)

	xsize = maxX- minX
	ySize = maxY - minY
	zSize = maxZ - minZ
	
	tgtSizeStr = stringstream ""
	format "target: \t%, %, %"  xsize ySize zSize to: tgtSizeStr
	print(tgtSizeStr as string)
	
	
	-- get ref ffd size
	if classof ref == dummy then
	(
		modFFD = ref.children[1].modifiers[#FFD_2x2x2]
	)
	else
	(
		for oneMod in ref.modifiers do 
		(
			if (classof onemod == FFD_2x2x2) do
			modFFD = oneMod
			break
		)
-- 		modFFD =  ref.modifiers[#FFD_2x2x2]
	)
	
-- 	print modFFD
	animateVertex  modFFD #all
-- 	print modFFD.control_point_1
-- 	modFFD.Control_Point_2

	-- calculate ffd size
	local boundMax, boundMin
	
	if classof ref == dummy then
	(
		boundMax = getModContextBBoxMax  ref.children[1] modFFD
		boundMin = getModContextBBoxMin  ref.children[1] modFFD
	)
	else
	(
		boundMax = getModContextBBoxMax  ref modFFD
		boundMin = getModContextBBoxMin  ref modFFD
	)
	xffd = boundMax.x - boundMin.x
	yffd = boundMax.y - boundMin.y
	zffd = boundMax.z - boundMin.z

	refSizeStr = stringstream ""
	format "ref: \t%, %, %"  xffd yffd zffd to: refSizeStr
	print (refSizeStr as string)
	
	
	-- calculate ratio
		-- apply ratio to ffd position or object scale?
	xRatio = xsize/xffd
	yratio = ysize/yffd
	zratio = zsize/zffd
	
	ratioStr = stringStream ""
	format "ratio: \t%, %, %"  xRatio yratio zratio to: ratioStr
	print(ratioStr as string)
	
	-- resize ffd
	
		-- duplicate ref 
	copyRef = undefined
	maxOps.cloneNodes ref cloneType:#instance newNodes:&newGrpArr

	if classof ref == dummy then
	(
-- 		maxOps.cloneNodes ref cloneType:#copy newNodes:&newGrpArr
-- 		select newGrpArr
		
		for n in newGrpArr do if classof n == dummy do 
		(
			copyRef = n
		)
	)
	else
	(
		copyRef = newGrpArr[1]
	)
	
	print copyRef
	
	--  place ref
	copyRef.rotation = tgt.rotation 
	copyRef.center = tgt.center
-- 	copyRef.pivot = copyRef.center
	
	--  resize ref
	copyref.scale = [xRatio, yRatio, zRatio]
	
	return copyref
	
)

fn replaceRefDef2 ref tgt =
(
	-- collect x,y and z max on target
	vertNum = tgt.GetNumVertices ()
	maxX = -1000
	minX = 1000
	maxY = -1000
	minY = 1000
	maxZ = -1000
	minZ = 1000
	
	for i = 1 to vertNum do
	(
		posTmp = tgt.getvertex i
		
		if posTmp.x > maxX do maxX = posTmp.x
		if posTmp.x < minX do minX = posTmp.x
		if posTmp.y > maxY do maxY = posTmp.y
		if posTmp.y < minY do minY = posTmp.y
		if posTmp.z > maxZ do maxZ = posTmp.z
		if posTmp.z < minZ do minZ = posTmp.z
	)

	xsize = maxX- minX
	ySize = maxY - minY
	zSize = maxZ - minZ
	
	tgtSizeStr = stringstream ""
	format "target: \t%, %, %"  xsize ySize zSize to: tgtSizeStr
	print(tgtSizeStr as string)

	-- add group on source
	-- open group
	-- calculate size of the ref
		-- bounding box of the group
	-- calculate ratio
	
	-- duplicate group source
	-- place copy
	-- scale copy
	-- close copy group
	-- explode copy group
	
	-- close grp source
	-- explode grp source
	
)

