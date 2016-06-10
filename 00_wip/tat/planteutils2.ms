-- plante utils

-- renaming parent ctrl
hlps = helpers as array
for h in helpers do
(
	res =  findstring h.name "Parent_CTRL" 
	if res != undefined then
	(
		oldName = h.name 
		h.name  = substituteString oldName "_CTRL" "_RIG"
	)
)

sel = selection as array
for s in sel do print s.scale
	
-- rename plante 
search = "FeuilleCycad"
change = "PlanteCycad_Feuille"

-- 	search = "FeuilleMajestyA"
-- 	change = "PlanteMajesty_PlanteA"

-- 	sel = selection as array

sel = objects as array
-- sel = selection as array
for s in sel do
(
	if classof s != TAT_AnimNode then
	(
		oldName = s.name 
		s.name  = substituteString oldName search change
	)
)

	-- rename par lettres
	objs = objects as array
	search = "13"
	change = "N"
	base = "Feuille"
	
	for o in objs do
	(
		res = findString  o.name (base + search)
		if res != undefined then
		(
			print o.name
			oldname = o.name
			o.name = substituteString oldname (base + search) (base + change)
			print o.name
		)
	)

-- reset skin
sel = selection as array
for s in sel do
(
	s.modifiers["skin"].ref_frame  = 20
	s.modifiers["skin"].always_deform = false
	s.modifiers["skin"].always_deform = true
-- 	s.modifiers["skin"].ref_frame  = 0
)	

-- resetxform in place
fn resetInPlace s =
(
	bakparent = s.parent
	bakChilds = for c in s.children collect c
		
	tmpPt = point rotation: s.rotation position: s.position name: (s.name + "_tmpPt")
	s.parent = tmpPt
	for c in bakChilds do c.parent = undefined
	resetxform s
	
	s.parent = bakparent
	for c in bakChilds do c.parent = s
		
	delete tmpPt
)

sel = selection as array
for s in sel do resetInPlace s

for s in sel do
(
	try( deleteModifier s s.modifiers["Xform"])catch()
)

-- reorient on child
fn reorientOnChild s =
(
	bakparent = s.parent
	bakChilds = for c in s.children collect c

	tmpPt = point rotation: s.rotation position: s.position name: (s.name + "_tmpPt")
	s.parent = tmpPt
	for c in bakChilds do c.parent = undefined
	tmpPt.rotation.controller = lookat_constraint pickUpNode: bakChilds[1] upnode_world: false
	tmpPt.rotation.controller.appendTarget bakChilds[1] 100
	tmpPt.rotation.controller.target_axis = 2
	tmpPt.rotation.controller.upnode_axis = 1
	tmpPt.rotation.controller.StoUP_axis = 1

	s.parent = bakparent
	for c in bakChilds do c.parent = s
	delete tmpPt
)

reorientOnChild $

-- reorient base

	-- collect bases
	hlps = helpers as array
	hlps_parent = #()
	base_ctrls = #()
	for h in hlps do
	(
		res = findString  h.name "RIG"
		if res != undefined then 
		(
			append hlps_parent h
			append base_ctrls h.children[1]
		)
		
	)
	select hlps_parent
	selectmore base_ctrls

	-- reorient parents
	fn reorientTochild s =
	(
		dad = s
		child = dad.children[1]
		-- deparent child
		child.parent = undefined
		-- orient dad sur child 
		dad.rotation = child.rotation
		dad.position = child.position
		-- reparent
		child.parent = dad
	)
	reorientTochild $

	for h in hlps_parent do reorientTochild h

-- create root
nameAr = filterString  maxFileName "_"
basename = nameAr[1] + "_" + nameAr[2]

ptRoot = point name: (basename + "_ROOT") wirecolor: (color 14 255 2)  size: 50 box: on cross: off axistripod: off centermarker: off
ptParent = point name: (basename + "_Parent_CTRL") wirecolor: (color 225 198 87) size: 50 box: off cross: on axistripod: off centermarker: off

ptParent.parent = ptRoot


-- 
m = $.modifiers["skin"]
addmodifier $ m



-- return controls
-- append conrols

-- return selset
s = $.modifiers["selset_anim"]
idNums = s.index.count

for j = 1 to idNums do
(
	print ""
	print s.names[j]
	for i = s.index[j] to (s.index[j] + s.sizes[j] - 1) do
	(
		print s.nodes[i]
	)
)
-- append selset


-- check scale
$.scale

objs = selection as array
for o in objs do
(
	format "obj: % ; scale: %\n" o.name o.scale
)	




-- trouver les objets avec Feuille##

fn renameWithLetter s =
(
	alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

	search = "Feuille"
	num
	ref = s.name

	refAr = filterString  ref "_"
	numOk = false
	endName  = ""

	for i = 4 to refAr.count do 
	(
		endName = endName + "_" + refAr[i]
	)

	res = matchpattern  ref  pattern: (refAr[1] + "_"+ refAr[2] + "_" + search + "??" + endname)

	-- récupérer le numero 
	if res == true do 
	(
		ref2 = substituteString ref (refAr[1] + "_"+ refAr[2] + "_" + search) ""
		numStr = substituteString ref2  endName ""
		try 
		(
			num = numStr as integer
			numOk = True
		)catch()
	)

	-- changer le nom
	newname = undefined
	if numOk == true then
	(
		-- convertir en lettre
		char = alphabet[(num as integer)+1]
		newname = refAr[1] + "_"+ refAr[2] + "_" + search + char + endName
		s.name = newname
	)
	else
	(
		format "pas renommable: %\n" s.name
	)
	
)

sel = selection as array
for s in sel do renameWithLetter s

-- add head of fk chain
rigName = substitutestring $.name "CTRL" "RIG"
tmpPt = point rotation: $.rotation position: $.position name: rigName axistripod: off box: off cross: on
$.parent = tmpPt


-- display pivot
fn displayPivot s =
(
	dispName =  s.name + "_dispPiv" 
	tmpPt = point rotation: s.rotation position: s.position name: dispName axistripod: true
	tmpPt.parent = s
)

sel = selection as array
for s in sel do displayPivot  s

-- REGEX

rx = dotnetobject "System.Text.RegularExpressions.Regex" "\_*"
filename = $.name
rx.isMatch filename

rx = dotnetobject "System.Text.RegularExpressions.Regex" "\w_[0-9]{4}.*"
filename = "Characters_Main_Velocity_v01_0634.jpg"
rx.isMatch filename
