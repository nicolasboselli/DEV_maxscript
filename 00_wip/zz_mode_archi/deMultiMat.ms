-- make one object by multi material


-- collect scene multimaterial

-- for one multimaterial
	-- collect object

-- for one object
	-- count multimaterial number
	multiTmp = $.material.count
	
	-- count objet id
	idMax = 0
	faceMax = $.GetNumFaces ()
	for i = 1 to faceMax do
	(
		polyop.setFaceSelection $ i
		if ($.getMaterialIndex true) > idMax do idMax = $.getMaterialIndex true
	)
	polyop.setFaceSelection $ #none
	print idMax
	
	tmpMat
	-- pour chaque id de l'objet a partir de 2:
	for i = 2 to idMax do
	(
		tmpMat = $.material
		-- detach faces with one material
		$.selectByMaterial  i
		newName = uniquename ($.name + "_mat_" + (i as string))
		polyop.detachFaces $ #selection delete: false asNode: true name: newName
		
		newSkin = getnodebyname newName
		
		-- option: split edge by smoothing group
		-- appliquer un shell sur le nouvel objet
		-- faire un outline sur l'objet
		-- rename object by material
		-- apply unique matching material
		newSkin.material = tmpMat[i]
	)
	
	$.material = tmpMat[1]

				
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

-- remove materiel
$.material = undefined


-- display scene material in medit material
for i = 1 to sceneMaterials.count do
(
	meditMaterials[i] = sceneMaterials[i]
)

-- convert standard to vray
vrMat = VRayMtl diffuse: meditMaterials[activeMeditSlot].diffuse name: meditMaterials[activeMeditSlot].name
replaceinstances meditMaterials[activeMeditSlot] vrMat
	
test =  meditMaterials[activeMeditSlot]
classof test
delete test

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

