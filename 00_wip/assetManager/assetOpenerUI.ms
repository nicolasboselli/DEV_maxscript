-- asset opener

/*
maj:
	-- dev add tag system
	-- merge asset
	-- update asset system
		-- list
	-- dev thumbnail editing
	-- dev status system
	-- dev comments system
	-- dev proxy system
	-- patch missing bitmap and missing vrmeshes  on editing and on merging
	-- clean pathname
	
	-- create asset on list item selected
	-- create one display asset list to sort asset
	
bug:
	-- change path folders to relative path 
	-- ecrire un patch pour conformer tous les assets incorrect (virer les version inexistante, marquer le bon nombre de version...)
	-- on save file when editing and cancel do stop editiing
	
*/


filein "assetManagerDef.ms"

-- scan asset folder to collect asset
fn walkDir dir pattern =
(
	assetArr = #()
    dirArr = GetDirectories (dir + "\\*")
 
    for d in dirArr do
    (
        join dirArr (getDirectories (d + "\\*"))
    )
 
    append dirArr (dir + "\\") -- Need to include the original top level directory
 
    for f in dirArr do
    (
		fileArr = getFiles (f + pattern)
		if fileArr.count> 0 do
		(
			for f in fileArr do
			(
				 append assetArr f
			)
		)
       
    )
	assetArr
)



struct assetClass
(
	assetInfo,
	assetFolder, 
	
-- 	allAssetsRoot,
-- 	allAssetsFolder,
-- 	relativeFolder,
-- 	relativeFolder2,
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
		name = getINISetting iniFile "assetProperties" "name"
		lastVersion = (getINISetting iniFile "assetProperties" "version") as integer
		versionInfo = assetsTank +  (returnDigit lastVersion) + "\\" + "versionInfo.ini" 
		
		assetFolder =cleanFilename(getFilenamePath assetInfo)
		
		lastVersionFile = assetFolder + "name"+ "\\" + (returnDigit lastVersion) +"\\" + name + ".max"
		wipFolder = assetFolder +"\\"+  "wip" + "\\"
		
-- 		allAssetsFolder = assetsTank
		
-- 		assetFolder =cleanFilename(getFilenamePath assetInfo)
		
		root = assetsTank + "\\"
-- 		assetFolder = root + name
-- 		relativeFolder = returnRelativeFolder assetFolder assetsTank
-- 		relativeFolder2 = returnRelativeFolder2 assetFolder assetsTank name
		
-- 		allAssetsRoot = returnRootPath assetFolder assetsTank

-- 		lastVersionFile = returnLastVersionFile versionInfo
-- 		lastVersionFile = assetsTank + (returnDigit lastVersion) +"\\" + name + ".max"
-- 		relVersPath = returnLastVersionRelativeFile()
		
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
		lastVersionFile = cleanFilename(assetFolder + "\\" + (returnDigit lastVersion) + "\\" + name + ".max")
		lastVersionFile
	)

)


rollout externalToolsRLT "asset tools"
(
	group "create asset:"
	(
		button createAssetBT "from scene..." across:2
		button createAssetFromSelBT "from selection..." 
	)
	button assetToolsBT "asset tools..." across:2
	button updateToolsBT "update tools..."
	
	on createAssetBT pressed do filein "assetPublisherUI.ms"
	on createAssetFromSelBT pressed do 
	(
		sel = selection as array
		if sel.count > 0 then filein "assetCreatorFromSelectionUI.ms"
		else print "make selection first"
	)
	on assetToolsBT pressed do filein "assetManagerTools.ms"
	on  updateToolsBT pressed do filein "updateAssetTool.ms"
)

rollout assetEditorRLT "assets editor"
(
	local maxIni = getMAXIniFile()
	local armadasScriptsIni = (getFilenamePath maxIni) + "armadasScriptsIni.ini"
	
-- 	local allAssetsFolder = "zz_ressources3D"
	local root 
	
	local assetPathsArr = #()
	local assetsList = #()
	
-- 	UI
-- 	edittext allAssetsFolderET "the \"all assets\" folder name:" text: allAssetsFolder readonly: true
	group "Assets Repository:"
	(
		edittext rootET "Path:" readonly: true
		button findFolderBT "..."
	)
		
	group "Assets List:"
	(
		edittext tagSearchET "search by tags:"
		edittext nameSearchET "search by name:"
		listbox assetsBL "Assets:"
		button collectAssetBT "refresh"
	)
-- 	rof.rollouts[2].assetsList[1].name
	
	group "Asset selected infos:"
	(
		bitmap assetBMP "asset thumbnail" width: 256 height: 256
		
-- 		edittext curAssetRootET "assets root: " readonly: true
-- 		edittext curAllAssetsFolderET "all assets folder: " readonly: true
-- 		edittext assetRelativePathET "asset relative path: " readonly: true
		edittext curAssetNameET "asset name:" readonly: true
		edittext versionET "last version:" readonly: true
		
		edittext absPathET "absolute path" readonly: true
-- 		edittext relVersionET "relative version" readonly: true

		edittext editableET "asset editable" readonly: true
 		
-- 		edittext openStatusET "status:"  readonly: true
-- 		edittext  openTagsET "tags:" readonly: true
		
-- 		checkbox instanceCB "new max instance"
		button openBT "open" across:3
		button editBT "edit" 
		button mergeBT "merge"
-- 		button updateBT "update"
	)
	
	group "publishing parameters:"
	(
		edittext nameET "name:" readonly: true		
		edittext nextVersET "next version:" readonly: true
		edittext publishStatusET "status:"  readonly: true
		
-- 		edittext commentET "comments:" height:150
		edittext publishTagsET "tags:" readonly: true
		button addTagsBT "add tags"
		
		button publishVersionBT "publish" enabled: false
	)
		
	fn refreshEditGroup asset =
	(
-- 		refresh root
-- 		curAssetRootET.text = asset.allAssetsRoot

-- 		refresh assets folder
-- 		curAllAssetsFolderET.text = asset.allAssetsFolder

-- 		refresh relative path
-- 		assetRelativePathET.text = asset.relativeFolder
		
-- 		refresh name
		if asset.name != undefined then curAssetNameET.text = asset.name else curAssetNameET.text = "UNDEFINED"

-- 		refresh version number
		if asset.lastVersion != undefined then versionET.text = returnDigit asset.lastVersion
		else versionET.text = "???"
		
-- 		refresh absolute version filename
		absPathET.text = asset.getLastVersionFile()
		
-- 		asset editable
		if doesfileexist (asset.getLastVersionFile()) == true then editableET.text = "true"
		else editableET.text = "false"
		
-- 		refresh thumbnail
		thumbFile =  asset.assetFolder + "\\" + "assetThumb.jpg"
		
		if doesfileexist thumbFile == true then assetBMP.filename = thumbFile
		else 
		(
			print "no thumbnail"
			assetBMP.bitmap = bitmap 256 256 color:(color 125 125 125)
		)
	)
	
	fn refreshPublishGroup asset =
	(
		-- test if asset folder ready
		nameOk = False
		nextVersionPossible = False
		
		-- check asset info file exists
		assetFileInfoExists = doesfileexist (asset.assetInfo)
		
		-- find asset name from folder name
		currentFile = maxFilePath
		currentFileName = undefined
		
		if currentFile.count >0 then
		(
			basefolder = getUpperFolder currentFile
			pathAr = filterString  basefolder "\\"
			currentFileName = pathAr[pathAr.count]
		)
		
		-- compare name with asset info
		assetName = asset.name
		
		if currentFileName == assetName then
		(
			nameET.text = assetName
			nameOk = true
		)
		else
		(
			nameET.text = "???"
		)
		
		-- find next version by count folders
		lastVersion = 0
		folderVersion = False
		assetFolders = getDirectories (asset.assetFolder + "\*")
		
		for f in assetFolders do
		(
			pathAr = filterString  f "\\"
			version = (pathAr[pathAr.count] as integer)
			if  version != undefined  then 
			(
				folderVersion = True
				if version> lastVersion then lastVersion = version
			)
		)

		-- compare with asset info
		assetVersion = asset.lastVersion
		
		versionText = "???"
		
		if folderVersion == true do
		(
			if assetVersion == lastVersion then
			(
				versionText = returnDigit (lastVersion + 1)
				nextVersionPossible = true
			)
		)
		nextVersET.text = versionText
		
		-- enable publishing
		if  assetFileInfoExists == true and	nameOk == true  and nextVersionPossible == true then
		(
			publishVersionBT.enabled = true
		)
		else
		(
			publishVersionBT.enabled = false
		)
	)
	
	fn collectAssets root =
	(
		assetPathsArr = walkDir  root "assetInfo.ini"
		tmpAssetsList = #()
		for a in assetPathsArr do
		(
			try
			(
				newAsset = assetClass()
				newAsset.initFromIni a root
-- 				allAssetsFolder
				append tmpAssetsList newAsset
			)catch()
		)
		tmpAssetsList
	)
	
	fn refreshListBox =
	(
		-- collect asset
		assetPathsArr = walkDir  root "assetInfo.ini"

		assetsList = #()
		
		for a in assetPathsArr do
		(
			try
			(
				newAsset = assetClass()
				newAsset.initFromIni a root
-- 				allAssetsFolder
				append assetsList newAsset
			)catch()
		)
		--	print assetsList
		
		-- refresh ui
		rootET.text = root
		
		assetsBL.items = for o in assetsList collect o.name	
		
		if assetsList.count >0 then
		(
			refreshEditGroup assetsList[1]
			refreshPublishGroup assetsList[1]
		)
	)
	
	/*
	fn sortMergedElts elts =
	(
		mergedElts = #()
		for o in elts do
		(
			if classof o == vraysun then delete o
			else if classof o == vrayplane then delete o
			else append mergedElts o
		)
		mergedElts
	)
	*/

	fn updateIni = setINISetting armadasScriptsIni "assetManager" "repositoryPath" root
	
	on assetEditorRLT open do
	(
-- 		root = @"J:\_svn\zz_ressources3D"
		
		local rootIni = getINISetting armadasScriptsIni "assetManager" "repositoryPath"
		if rootIni.count > 0 then
		(
			if doesfileexist rootIni == true then root = rootIni
		)
		
		refreshListBox()
	)
	
	on assetEditorRLT close do updateIni()
	
	on findFolderBT pressed do
	(
		if root != undefined then res = getSavePath caption: "chose folder"  initialDir: root
		else res = getSavePath caption: "chose folder" 

		if res != undefined then
		(
			print res
			root = res
			refreshListBox()
			updateIni()
		)
		else
		(
			print "fail!"
		)
	)
	
	on collectAssetBT pressed do refreshListBox()
	
	on assetsBL selected obj do
	(
		refreshEditGroup assetsList[obj]
		refreshPublishGroup assetsList[obj]
	)
	
	on openBT pressed do
	(
		asset = assetsList[assetsBL.selection]
		print asset.assetFolder
		doscommand ("explorer " + asset.assetFolder)
	)
	
	on editBT pressed do
	(
		asset = assetsList[assetsBL.selection]

		assetFile =  asset.getLastVersionFile()
		
		print ("assetfile: " + assetFile)
		
		if assetFile.count>0 then
		(
			if doesFileExist assetFile == true then
			(
				vers = asset.lastVersion
				assetName = asset.name
				wipFolder = asset.wipFolder
				print wipFolder
				
				wipFile = wipFolder + "\\" + assetName +"_" + returnDigit vers + "_" + "wip" + "_" + (localTimeStr()) + "_00.max"

				test = copyFile assetFile wipFile
				if test == true then
				(
					if checkForSave()  == true do loadMaxFile wipFile
				)
				else print "wip copy fail"
			)
			else print "can't find file"
		)
		else print "uncorrect filename"

		
		refreshEditGroup assetsList[assetsBL.selection]
		refreshPublishGroup assetsList[assetsBL.selection]
	)
	
	on publishVersionBT pressed do
	(
		print "publish"
		currentAsset = assetsList[assetsBL.selection]
		newFolder = currentAsset.assetFolder +"\\" +  (returnDigit(currentAsset.lastVersion + 1))
				
		-- create folder
		folderCreated = makedir newFolder all: true
		
		-- save file
		local newFile
		if folderCreated == true then
		(
			newFile =  newFolder + "\\" + currentAsset.name + ".max" 
			newfileCreated = saveMaxFile newFile useNewFile: false
			print newfileCreated
		)
		
		if newfileCreated == true then
		(
			currentAsset.lastVersion = currentAsset.lastVersion + 1
			currentAsset.lastVersionFile = newFile
			-- update asset info file
			currentAsset.updateAssetFileInfo()
			-- create version info file
			currentAsset.createVersionFileInfo()
		)
		else
		(
-- 			delete folder
		)

		refreshListBox()
		
		refreshEditGroup assetsList[assetsBL.selection]
		refreshPublishGroup assetsList[assetsBL.selection]
		
	)

	on mergeBT pressed do
	(
		asset = assetsList[assetsBL.selection]
		ctrl = asset.mergeAsset()
		select ctrl
	)
)


-- try(destroyDialog assetEditorRLT)catch()
try(closeRolloutFloater  rof)catch()
rof= newrolloutfloater "Asset Editor" 600 900
addrollout externalToolsRLT rof
addrollout assetEditorRLT rof

-- createdialog assetEditorRLT width: 200

