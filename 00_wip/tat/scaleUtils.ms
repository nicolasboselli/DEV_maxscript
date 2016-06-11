-- print scale
for s in selection do
(
	format "name: %, scale: %, value: %, offset: %\n" s.name s.scale s.scale.controller.value s.objectoffsetscale
)

sel = selection as array
sel[2].scale.controller.value = sel[1].scale.controller.value 


-- rescale to 1, except biped

for s in selection do
(
	res = findstring  s.name "BIP"
	if res == undefined then
	(
		s.scale =  [1,1,1]
	)
)

$.scale = [1,1,1]
$.scale.controller.value = [1,1,1]

for s in selection do
(
	res = findstring  s.name "BIP"
	if res == undefined then
	(
		s.scale.controller.value = [1,1,1]
-- 		s.objectoffsetscale = [1,1,1]
	)
)



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

-- insert offsetscale rig
fn insertScaleOffset s =
(
	-- collecter parent et enfant de sel
	bakparent = s.parent
-- 	bakChilds = for c in s.children collect c
	
	-- creer point
	tmpPt = point rotation: s.rotation position: s.position name: (substitutestring s.name "_CTRL" "_ScaleOffset_RIG")
	s.parent = tmpPt
	tmpPt.parent = bakparent

)
insertScaleOffset $


fn insertNCorrectScaleOffset s =
(
	-- collecter parent et enfant de sel
	bakparent = s.parent
-- 	bakChilds = for c in s.children collect c
	
	-- creer point
	tmpPt = point rotation: s.rotation position: s.position scale: s.scale.controller.value name: (substitutestring s.name "_CTRL" "_ScaleOffset_RIG")
	s.parent = tmpPt
	redrawViews() 
	tmpPt.parent = bakparent

)
insertNCorrectScaleOffset $





$.transform.controller[1].bipscalelist[1].controller.value
$.transform.controller[1].bipscalelist[1].controller.value = [1,1,1]

sel = selection as array

sel[2].scale.controller.value = sel[1].scale.controller.value


-- change bipskin
bsAr = #()
geom = geometry as array
for g in geom do
(
	res = findstring g.name "_BIPSKIN"
	if res != undefined then append bsAr g
)
select bsAr

bxAr = #()
geom = geometry as array
for g in geom do
(
	res = findstring g.name "_BOXBIP"
	if res != undefined then append bxAr g
)
select bxAr




bipAr = #()
for bs in bsAr do
(
	search = substitutestring bs.name "_BIPSKIN" "_BIP"
	res = getnodebyname search
	if res != undefined then append bipAr res
)
select bipAr
selectmore bsAr





-- reparent
for s in selection do
(
	dad = s.parent
	for c in s.children do c.parent = dad
)

-- switch _bipskin to _rig
for s in selection do
(
	switchPt = point rotation: s.rotation position: s.position scale: s.scale name: (substitutestring s.name "_BIPSKIN" "_Offset_RIG")
	dad = s.parent
	switchPt.parent = s.parent
	for c in s.children do c.parent = switchPt
)


-- find offset scale 
offsAr = #()
geom = helpers as array
for g in geom do
(
	res = findstring g.name "_Offset_RIG"
	if res != undefined then append offsAr g
)
select offsAr

bbpAr = #()
for offs in offsAr do
(
	search = substitutestring offs.name "_Offset_RIG" "_BOXBIP"
	res = getnodebyname search
	if res != undefined then append bbpAr res
)
select bbpAr
selectmore offsAr


-- transfert parent
for o in offsAr do
(
	search = substitutestring o.name "_Offset_RIG" "_BOXBIP"
	res = getnodebyname search
	if res != undefined then
	(
		format "parent: %, boxbip: %, offset: %\n" o.parent.name res.name o.name
		res.parent = o.parent
	)
	else(format "fail: % \n" o.name)
-- 	delete o
)

for o in offsAr do
(
	if  o.children.count == 0 do selectmore o
)


