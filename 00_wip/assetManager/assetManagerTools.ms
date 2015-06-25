filein "assetManagerDef.ms"

/*
maj create thumbnail:
	-- check if there are in an asset folder
	-- add version on thumbnail
*/


-- collect vrmeshes
fn collectVrMeshes =
(
	geomAr = geometry as array

	assetFolder = getUpperFolder maxFilePath

	iniFiles = getfiles (assetFolder + "assetInfo.ini")
	-- print iniFiles.count

	if iniFiles.count > 0 then
	(
		for o in geomAr do
		(
			if classof o == vrayproxy then
			(
				vrmeshesFolder = assetfolder + "vrmeshes"
				
				dir = getDirectories vrmeshesFolder
				if dir.count == 0 then res = makedir vrmeshesFolder
					
				vrmeshFile = o.filename
				vrmeshName = getFilenameFile vrmeshFile
				
				newFile = vrmeshesFolder + "\\" + vrmeshName + ".vrmesh"

				res = copyfile vrmeshFile newFile
				if res == true then
				(
					o.filename = newFile
				)
			)
		)
	)
)





-- create vrmeshes
-- collect map
test = getClassInstances  bitmaptex   processAllAnimatables:true
fileToCopy = for t in test where doesfileexist t.filename ==  true collect t.filename 
print fileToCopy

-- create topnode


-- create thumbnail
fn createThumb =
(
	outPath =  ((getUpperFolder maxFilePath) + "assetThumb.jpg") 
	bmpTmp = bitmap 256 256 gamma: 0.2 filename: outPath
	render vfb: on to: bmpTmp 
	
	save bmpTmp
	close bmpTmp
		
	outPath =  ((getUpperFolder maxFilePath) + "assetPreviz.jpg") 
	bmpTmp = bitmap 1024 1024 gamma: 0.42 filename: outPath
	render vfb: on to: bmpTmp 

	save bmpTmp
	close bmpTmp
)


-- rollout
try(destroyDialog assetsToolsRLT)catch()

rollout assetsToolsRLT "asset tools"
(
	button collectVrayMeshesBT "collect vraymeshes"
	button createThumbBT "create thumbnail"
	
	on collectVrayMeshesBT pressed do collectVrMeshes()
	on createThumbBT pressed do createThumb()
)
createdialog assetsToolsRLT