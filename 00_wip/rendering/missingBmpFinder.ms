sceneMatAr = scenematerials

badMatAr = #()

for mat in sceneMatAr do
(
	bitmapAr = getClassInstances  bitmaptex   target: mat

	for f in bitmapAr where f.filename != undefined do
	(
		
		if doesfileexist f.filename != true then
		(
			bmpTmp = openBitmap ((getFilenameFile f.filename) + (getFilenameType f.filename))
			if bmpTmp != undefined then
			(
				format "founded: %\n"  bmpTmp.filename
				f.filename = bmpTmp.filename
-- 				print bmpTmp.filename
			)
			else 
			(
				format "really missing: %\n"  f.filename
				appendifunique badMatAr mat
-- 				appendifunique badMatAr mat
			)
		)
	)		
)



-- bmpTmp = openbitmap "mpm_vol.06_p04_01_diff.JPG"

if badMatAr.count == 0 then print "scene clean"
else
(
	for i = 1 to badMatAr.count do
	(
		meditmaterials[i] = badMatAr[i]
	)
)

/*

test = meditMaterials[activeMeditSlot]
bitmapAr = getClassInstances  bitmaptex   target: test

for f in bitmapAr do print  f.filename 
	
enumerateFiles print #missing

enumerateFiles()
*/