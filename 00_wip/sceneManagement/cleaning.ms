objs = objects as array

for o in objs where classof o == railclone_pro do
(
	o.vmesh = 0
)

for o in objs where classof o == railclone_pro do
(
	converttopoly o
)


objs = objects as array
for o in objs where o.modifiers.count >= 1 do
(
	for m in o.modifiers where classof m == sweep do
	(
		format "obj: %, mod: %\n" o m
		converttopoly o
	)
)
	
-- VRayEdgesTex ()
-- meditMaterials[21].texmap_bump.widthType = 0
-- meditMaterials[21].texmap_bump.thickness = 0.2

vrEdge = VRayEdgesTex widthType: 0 thickness: 0.2
meditMaterials[activeMeditSlot].texmap_bump = vrEdge