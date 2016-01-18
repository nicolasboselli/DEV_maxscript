car = geometry as array
select car
-- remove meshsmooth
print car.count
for o in car do 
(
	mshMod = o.modifiers["MeshSmooth"]
	if mshMod != undefined do
	(
		deleteModifier  o  mshMod
		print o
	)
	
)

-- collect object with modifier
test = #()
for o in car do
(
	if o.modifiers.count > 0 do
	(
		append test o
	)
)
select test

-- meditmaterials[activeMeditSlot].refraction_subdivs

-- diminue reflection sample
for mat in scenematerials do
(
	if classof mat == vraymtl then
	(
		if mat.reflection_subdivs > 8 do mat.reflection_subdivs = 8
		if mat.refraction_subdivs > 8 do mat.refraction_subdivs = 8
	)
	else if classof mat == multimaterial then
	(
		for m in mat do
		(
			if classof m == vraymtl then
			(
				if m.reflection_subdivs > 8 do m.reflection_subdivs = 8
				if m.refraction_subdivs > 8 do m.refraction_subdivs = 8
			)
		)
	)
)


-- collect non vraymtl
matList = #()

for mat in scenematerials do
(
	if classof mat == multimaterial then
	(
		for m in mat do
		(
			if classof m != vraymtl then
			(
				appendifunique matList m
			)
		)
	)
	else if classof mat != vraymtl then
	(
		appendifunique matList mat
	)
)

for i= 1 to matList.count do
(
	meditmaterials[i] = matList[i]
)

-- collect vraymtl with displacement
dispMat = #()
for mat in scenematerials do
(
	if classof mat == multimaterial then
	(
		for m in mat do
		(
			if classof m == vraymtl then
			(
				if m.texmap_displacement != undefined then
				(
					print m
					appendifunique dispMat m
				)
			)
		)
	)
	else if classof mat == vraymtl then
	(
		if mat.texmap_displacement != undefined then
		(
			print mat
			appendifunique dispMat mat
		)
	)
)
for i= 1 to dispMat.count do
(
	meditmaterials[i] = dispMat[i]
)


-- look for one map
fn readMat mat=
(
	test = mat
	goodMap = undefined
	for i = 1 to test.numSubs where test[i].value != undefined do 
	(
		if test[i].numSubs > 0 then
		(
			for j = 1 to test[i].numSubs where test[i][j].value != undefined do
			(
				if classof test[i][j].value == Raytrace then 
				(
					goodMap = test[i][j]
					format "mat: % ,subAnim: %, value: %, class: %. \n" mat goodmap goodmap.value (classof goodmap.value)
				)
			)
		)
		else
		(	if classof test[i].value == Raytrace then 
			(
				goodMap = test[i]
				format "mat: % ,subAnim: %, value: %, class: %. \n" mat goodmap goodmap.value (classof goodmap.value)
			)
		)
	)
	goodMap
)
readMat meditmaterials[activeMeditSlot]

-- collect raytrace 
goodMatAr = #()
for mat in scenematerials do
(
	if classof mat == multimaterial then
	(
		for m in mat do
		(
			if classof m == vraymtl or  classof m == standard then
			(
				res = readMat m
				if res!= undefined then append goodMatAr m
			)
		)
	)
	else if classof mat == vraymtl or  classof mat == standard then
	(
		res = readMat mat
		if res!= undefined then append goodMatAr m
	)
	else 
	(
		format "**************** mat: %\n" mat
	)
)
goodMatAr

meditmaterials[activeMeditSlot] = goodMatAr[1]






