sceneMatAr = scenematerials

badMatAr = #()

for mat in sceneMatAr do
(
	bitmapAr = getClassInstances  bitmaptex   target: mat
	
	for f in bitmapAr where f.filename != undefined do
	(
		if doesfileexist f.filename != true then
		(
			appendifunique badMatAr mat
		)
	)		
)

print "collect done"
if badMatAr.count == 0 then print "scene clean"
else
(
	for i = 1 to badMatAr.count do
	(
		meditmaterials[i] = badMatAr[i]
	)
)



