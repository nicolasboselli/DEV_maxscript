/*
maj:
-- one structure for all asset
	-- init from scene
		-- file name construction: root + assets folderName + relativePath + assetname + version + assetName + ".max"
	-- init from selection
	-- init from ini file
	-- init from controller

-- conf: asset tank: zz_ressources3D
-- include merge as method of asset class
	-- parameters:
		-- root
		-- relative path
		-- asset name
		-- last version
*/
fn localTimeStr =
(
	timeAr = getLocalTime() 
	timeStr = stringstream ""
	format "%_%_%_%_%_%_%" timeAr[1] timeAr[2] timeAr[4] timeAr[5] timeAr[6] timeAr[7] timeAr[8] to: timeStr
	timeStr as string
)

-- getUpperFolder maxFilePath
fn getUpperFolder currentPath =
(
	pathAr = filterString  currentPath "\\"
	
	-- test if there is an hardisk path or unc path
	if pathAr.count > 1 then 	res = findString pathAr[1] ":"
	
	-- 
	if res == undefined then upperPath = "\\\\"
	else upperPath = ""
		
	for i = 1 to (pathAr.count - 1) do upperPath =upperPath + pathAr[i] + "\\"

	upperPath
)	

fn returnAllHierarchyDown selArray=
(
	for s in selArray do
	(
		if s.children.count > 0 then
		(
			for c in s.children do  append selArray c
		)
		
	)
-- 	print selArray
	selArray
)



fn cleanFilename filename =
(
	test =substituteString filename "\\\\" "\\"
	test
)

fn publishVersion pathbase assetName version =
(
	-- create folder
	newFolder = pathbase + "\\" + assetName +"\\" + (returnDigit version)
	newFolder
	makeDir newFolder	
	-- create version info file
	-- update asset info file
	-- save version max file
)


fn returnDigit num =
(
	numStr = ""
	if num<=9 then numStr = "00" + (num as string)
	else if num>9 then numStr = "0" + (num as string)
	else if num>99 then numStr = (num as string)
	numStr
)

/*
struct assetFromSelClass
(
	basefolder,
	name,
	version,
	
	fn initFromSel sel
	(
		
	)
)
*/
struct assetClass
(
	assetInfo,
	assetFolder, 
	
	allAssetsRoot,
	allAssetsFolder,
	relativeFolder,
	relativeFolder2,
	name,
	lastVersion,
	
	root,

	wipFolder,
	
	versionInfo,
	lastVersionFile,
	
	relVersPath,
	
	fn returnRootPath onePath folderName=
	(
		oneRoot
		count = findString onePath folderName
		subTest = substring onePath 1 (count - 2)
		rootTmp = subTest -- + folderName
		
		if (getDirectories rootTmp).count > 0 then oneRoot = (rootTmp + "\\") else oneRoot = undefined
		oneRoot
	),
	
	fn returnRelativeFolder onePath folderName  =
	(
		count = findString onePath folderName
		subTest = substring onePath count -1
		relPathTmp = substituteString  subTest folderName  ""
		relPathTmp
	),
	
	fn returnRelativeFolder2 onePath folderName oneName =
	(		
		count = findString onePath folderName
		subTest = substring onePath count -1
		relPathTmp = substituteString  subTest folderName  ""
		relPath = cleanFilename(substituteString  relPathTmp oneName  "")
		relPath
	),
	
	fn returnLastVersionFile versionInfoFile =
	(
		oneLastVersionFile = undefined
		if doesfileexist versionInfoFile == true then
		(
			versionFileTmp = (getFilenamePath versionInfo) + name + ".max"
			if doesfileexist versionFileTmp == true then oneLastVersionFile = versionFileTmp
		)
		oneLastVersionFile
	),
	
	fn returnLastVersionRelativeFile =
	(
		tmp = relativeFolder + (returnDigit lastVersion) +"\\" + name + ".max"
		tmp
	),
	
	fn initFromIni iniFile assetsTank =
	(
		print "start init"
		
		assetInfo = iniFile
		name = getINISetting assetInfo "assetProperties" "name"
		allAssetsFolder = assetsTank
		
		assetFolder =cleanFilename(getFilenamePath assetInfo)
		
		relativeFolder = returnRelativeFolder assetFolder assetsTank
		relativeFolder2 = returnRelativeFolder2 assetFolder assetsTank name
		
		allAssetsRoot = returnRootPath assetFolder assetsTank
		
		root = allAssetsRoot  + allAssetsFolder + "\\"
		

		lastVersion = (getINISetting assetInfo "assetProperties" "version") as integer
		wipFolder = assetFolder +  "wip" + "\\"
		
		versionInfo = (assetFolder +  (returnDigit lastVersion) + "\\" + "versionInfo.ini" )
		lastVersionFile = returnLastVersionFile versionInfo
		relVersPath = returnLastVersionRelativeFile()
		
		print " init done"
	),
	
	
	fn updateAssetFileInfo =
	(
		setINIsetting assetInfo "assetProperties" "version" (lastVersion as string)
	),
	
	fn createVersionFileInfo =
	(
		versionInfoIniFile = assetFolder + "\\" +(returnDigit lastVersion ) +"\\" + "versionInfo.ini"
		versionInfoFileStream = createFile versionInfoIniFile
		close versionInfoFileStream
				
		setINISetting versionInfoIniFile "assetProperties" "name" name
-- 		setINISetting versionInfoIniFile "assetProperties" "versionFile" lastVersionFile
-- 		setINISetting versionInfoIniFile "assetProperties" "relativeVersionFile" relVersPath
		setINISetting versionInfoIniFile "assetProperties" "lastVersion" (lastVersion as string)
	),
		

	
	fn mergeAsset =
	(
		assetCtrl = undefined
		res = mergeMAXFile lastVersionFile   #select #autoRenameDups #useSceneMtlDups 
		
		if res == true then
		(
			sel = selection as array
			assetCtrl = point name: (uniquename( name + "_ctrl")) size: 200
			setUserProp assetCtrl "asset" true
			
			setUserProp assetCtrl "root" root
			setUserProp assetCtrl "relativePath" relVersPath
			
			setUserProp assetCtrl "allAssetsRoot" allAssetsRoot
			setUserProp assetCtrl "allAssetsFolder" allAssetsFolder
			setUserProp assetCtrl "relativeFolder" relativeFolder
			setUserProp assetCtrl "relativeFolder2" relativeFolder2
			
			setUserProp assetCtrl "assetName"  name
			setUserProp assetCtrl "assetVersion" lastVersion
			
			mergedElts = #()
			for o in sel do
			(
				if classof o == vraysun then delete o
				else if classof o == vrayplane then delete o
				else if classof o == targetcamera then delete o
				else if  o.parent == undefined then
				(
					o.parent = assetCtrl
				)
			)
		)
		
		assetCtrl
	),
	
	fn getLastVersionFile =
	(
		lastVersionFile = allAssetsRoot + allAssetsFolder + relativeFolder + (returnDigit lastVersion) + "\\" + name + ".max"
		lastVersionFile
	)

)

struct assetInScene
(
	obj,
	name,
	version,
	root,
	versionFile,
	assetFolder,
	assetIni,
	
	lastVersion,
	lastVersionFile,
	isLastVersion,
	
	allAssetsRoot,
	allAssetsFolder,
	relativeFolder,
	relativeFolder2,
	
	
	fn initFromCtrl oneCtrl=
	(
		obj = oneCtrl
		name = getuserprop obj "assetName"
		version = getuserprop obj "assetVersion"
		
		allAssetsRoot = getuserprop obj "allAssetsRoot"
		allAssetsFolder = getuserprop obj "allAssetsFolder"
-- 		print allAssetsFolder
		relativeFolder = getuserprop obj "relativeFolder"
		relativeFolder2 = getuserprop obj "relativeFolder2"
		
		-- obsolete root and relativePath
		root = getuserprop obj "root"
		versionFile = root + (getuserprop obj "relativePath")
-- 		print versionFile
		assetFolder = getupperfolder(getFilenamePath  versionFile)
		assetIni = assetFolder + "assetInfo.ini"
-- 		print assetIni
		
		lastVersion = (getINISetting assetIni "assetProperties" "version") as integer
-- 		print lastVersion
		lastVersionFile = assetFolder + (returnDigit lastVersion) + "\\" + name + ".max"
		
		isLastVersion = true
		if lastVersion > version and doesfileexist lastVersionFile ==  true then isLastVersion = false
		
		relVersPath = relativeFolder + (returnDigit lastVersion) +"\\" + name + ".max"
	),
	
	fn updateAsset =
	(
		newAsset = assetClass()
		newAsset.initFromIni assetIni allAssetsFolder
		newAssetCtrl = newAsset.mergeAsset()
		newAssetCtrl.transform = obj.transform
		newAssetCtrl
	)
)

