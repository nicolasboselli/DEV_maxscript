filein "assetManagerDef.ms"

/*
maj create thumbnail:
	x-- check if there are in an asset folder
	-- add version on thumbnail
	-- clean wip folder
*/


-- collect vrmeshes
fn collectOneVrMesh o=
(
	assetFolder = getUpperFolder maxFilePath
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


fn checkAssetFolder =
(
	assetFolder = getUpperFolder maxFilePath
	test = doesfileexist (assetFolder + "assetInfo.ini")
	test 
)

fn createVrMeshesFolder =
(
	vrmeshesFolder = undefined
	vrmeshesFolderExist = False
	
	vrmeshesFolderTmp = ((getupperfolder maxFilePath) + "vrmeshes")
	print vrmeshesFolderTmp
	res = getDirectories vrmeshesFolderTmp
	if res.count == 0 then 
	(
		vrmeshesFolderExist = makedir vrmeshesFolderTmp
		if vrmeshesFolderExist == true do	vrmeshesFolder = vrmeshesFolderTmp
	)
	else vrmeshesFolder = vrmeshesFolderTmp

	vrmeshesFolder
)


fn createTexturesFolder =
(
	texturesFolder = undefined
	texturesFolderExist = False
	
	texturesFolderTmp = ((getupperfolder maxFilePath) + "textures")
	print texturesFolderTmp
	res = getDirectories texturesFolderTmp
	if res.count == 0 then 
	(
		texturesFolderExist = makedir texturesFolderTmp
		if texturesFolderExist == true do	texturesFolder = texturesFolderTmp
	)
	else texturesFolder = texturesFolderTmp

	texturesFolder
)

-- create vrmeshes
-- collect map

fn copyTextures textFolder =
(
	bitmapAr = getClassInstances  bitmaptex   processAllAnimatables:true

	for t in bitmapAr where doesfileexist t.filename ==  true do
	(
		f = t.filename 
		newFile = textFolder + "\\"+  (filenameFromPath f)
		res = copyfile f newFile
		print res
		if res == true then t.filename = newFile
	)
)

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


fn createOneVrmesh s folder =
(
	vrmeshFile = folder + "\\" +s.name
	vrayMeshExport meshFile: vrmeshFile  maxPreviewFaces:500 exportMultiple: true autoCreateProxies: true exportPointClouds: false
)


-- rollout
try(destroyDialog assetsToolsRLT)catch()

rollout assetsToolsRLT "asset tools"
(
	button collectVrayMeshesBT "collect vraymeshes" enabled: false
	button createVrayMeshesBT "create vrmeshes from selection" enabled: false
	
	button collectTexturesBT "collect textures" enabled: false
	button createThumbBT "create thumbnail" enabled: false
	
	on assetsToolsRLT open do
	(
		if checkAssetFolder() == true then
		(
			collectVrayMeshesBT.enabled = true
			createVrayMeshesBT.enabled = true
			collectTexturesBT.enabled = true
			createThumbBT.enabled = true
		)
		else
		(
			print "you are not in an asset folder"
		)
	)
	
	on collectVrayMeshesBT pressed do
	(
		vrProxies = for o in geometry where classof o == vrayproxy collect o
		for vr in vrProxies do collectOneVrMesh vr
	)	
	
	on createVrayMeshesBT pressed do 
	(
		sel = selection as array
		vrmeshFolder = createVrMeshesFolder()
		print vrmeshFolder
		if vrmeshFolder != undefined then
		(
			for s in sel do createOneVrmesh s vrmeshFolder
		)
	)
	
	on collectTexturesBT pressed do
	(
		textFolder = createTexturesFolder()
		if textFolder != undefined then 
		(
			copyTextures textFolder
		)
	)
	
	on createThumbBT pressed do createThumb()
)
createdialog assetsToolsRLT