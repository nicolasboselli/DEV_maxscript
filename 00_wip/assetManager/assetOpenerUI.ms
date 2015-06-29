-- asset opener
test =substituteString @"J:\_svn\zz_ressources3D\MentorsPlants\\plants_collection1\\max\\ash_tree_002\\wip\ash_tree_002_002_wip_2015_6_28_11_12_4_331_00.max"  "\\\\" "\\"
test
/*
maj:
	-- dev add tag system
	-- merge asset
	-- update asset system
	-- dev thumbnail editing
	-- dev status system
	-- dev comments system
	-- patch missing bitmap and missing vrmeshes  on editing and on merging
	-- clean pathname
	
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

fn localTimeStr =
(
	timeAr = getLocalTime() 
	timeStr = stringstream ""
	format "%_%_%_%_%_%_%" timeAr[1] timeAr[2] timeAr[4] timeAr[5] timeAr[6] timeAr[7] timeAr[8] to: timeStr
	timeStr as string
)



rollout assetEditorRLT "assets editor"
(
	local root = @"J:\_svn\zz_ressources3D"
	local assetPathsArr = #()
	local assetsList = #()
	
	struct assetClass
	(
		assetInfo,
-- 		assetFolder = getINISetting assetInfo "assetProperties" "path",
		assetFolder =getFilenamePath assetInfo, 
		name = getINISetting assetInfo "assetProperties" "name",
		lastVersion = (getINISetting assetInfo "assetProperties" "version") as integer,
		wipFolder =assetFolder +  "\wip",
		
		versionInfo = (assetFolder + "\\" +  (returnDigit lastVersion) + "\\" + "versionInfo.ini" ),
		lastVersionFile = getINISetting versionInfo "assetProperties" "versionFile",
	
		fn setRelVersPath =
		(
			relPath = ""
			if doesfileexist versionInfo == true then
			(
				relPath = getINISetting versionInfo "assetProperties" "relativeVersionFile"
				
				if relPath.count == 0 and lastVersionFile.count > 0 then
				(
					count = findString lastVersionFile "zz_ressources3D"
					subTest = substring lastVersionFile count -1
					relPath = substituteString  subTest "zz_ressources3D"  ""
				)
				else if  relPath.count == 0  and lastVersionFile.count == 0 then
				(
					relPath = "xxxx"
				)
			)
			else
			(
				relPath = "???"
			)
			print("relative path: " + relPath)
			relPath
		),
		
		relVersPath = setRelVersPath(),
		
		fn createVersionFileInfo =
		(
			print "youhou"
			versionInfoIniFile = assetFolder + "\\" +(returnDigit lastVersion ) +"\\" + "versionInfo.ini"
			versionInfoFileStream = createFile versionInfoIniFile
			close versionInfoFileStream
			
			setINISetting versionInfoIniFile "assetProperties" "name" name
			setINISetting versionInfoIniFile "assetProperties" "versionFile" lastVersionFile
			setINISetting versionInfoIniFile "assetProperties" "relativeVersionFile" relVersPath
			setINISetting versionInfoIniFile "assetProperties" "lastVersion" (lastVersion as string)
		),
		
		
		fn updateAssetFileInfo =
		(
			setINIsetting assetInfo "assetProperties" "version" (lastVersion as string)
		)
	)
	
	group "assets list"
	(
		edittext tagSearchET "search by tags:"
		edittext nameSearchET "search by name:"
		listbox assetsBL "Assets:"
	)
	
	group "asset selected infos:"
	(
		bitmap assetBMP "asset thumbnail" width: 256 height: 256 gamma:10
		edittext curAssetNameET "name:" readonly: true
		edittext absPathET "absolute path" readonly: true
		edittext relVersionET "relative version" readonly: true
		
		edittext versionET "last version:" readonly: true

		edittext editableET "asset editable" readonly: true
 		
		edittext openStatusET "status:"  readonly: true
		edittext  openTagsET "tags:" readonly: true
		
-- 		checkbox instanceCB "new max instance"
		button openBT "open" across:2
		button editBT "edit" 
		button mergeBT "merge" across:2
		button updateBT "update"
	)
	
	group "publishing parameters:"
	(
		edittext nameET "name:" readonly: true		
		edittext nextVersET "next version:" readonly: true
		edittext publishStatusET "status:"  readonly: true
-- 		edittext superclassET "tags:" readonly: true
-- 		edittext classET "class:" readonly: true
-- 		edittext commentET "comments:" height:150
		edittext publishTagsET "tags:" readonly: true
		button addTagsBT "add tags"
		
		button publishVersionBT "publish" enabled: false
	)
	
	fn refreshListBox =
	(
		assetPathsArr = walkDir  root "assetInfo.ini"
		
		assetsList = for a in assetPathsArr collect assetClass assetInfo: a
		
		assetsBL.items = for o in assetsList collect o.name
	)
	
	fn refreshEditGroup asset =
	(
-- 		refresh name
		curAssetNameET.text = asset.name
		
-- 		refresh ini path
		absPathET.text = asset.assetFolder

-- 		relative path
		
-- 		last version file
		relVersionET.text = asset.relVersPath
		
		if doesfileexist (root + asset.relVersPath) == true then editableET.text = "true"
		else editableET.text = "false"
		
-- 		refresh thumbnail
		thumbFile =  asset.assetFolder + "\\" + "assetThumb.jpg"
		
		if doesfileexist thumbFile == true then assetBMP.filename = thumbFile
		else 
		(
			print "no thumbnail"
			assetBMP.bitmap = bitmap 256 256 color:(color 125 125 125) 
		)
		
-- 		refresh version number
		if asset.lastVersion != undefined then versionET.text = returnDigit asset.lastVersion
		else versionET.text = "???"
	)
	

	
	fn refreshPublishGroup asset =
	(
		-- test if asset folder ready
		
		-- check asset info file exists
		nameOk = False
		nextVersionPossible = False
		
		/*
		res = getfiles (asset.assetFolder + "\\assetInfo.ini" )
				
		if res.count != 1 then assetFileInfoExists = false 
		else assetFileInfoExists = true
		*/
		
		assetFileInfoExists = doesfileexist (asset.assetFolder + "\\assetInfo.ini" )
		
		-- find asset name from folder name
		currentFile = maxFilePath
		currentFileName = undefined
		
		if currentFile.count >0 then
		(
			basefolder = getUpperFolder currentFile
			pathAr = filterString  basefolder "\\"
			currentFileName = pathAr[pathAr.count]
		)
			-- compare with asset info
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
	
	on assetEditorRLT open do
	(
		refreshListBox()
	)
	
	on assetsBL selected obj do
	(
		refreshEditGroup assetsList[obj]
		refreshPublishGroup assetsList[obj]
	)
	
	on openBT pressed do
	(
		asset = assetsList[assetsBL.selection]
		
		print asset.assetFolder
	)
	
	on editBT pressed do
	(
		sel = assetsBL.selection

		assetFile =   root + assetsList[sel].relVersPath
		print ("assetfile: " + assetFile)
		
		if assetFile.count>0 then
		(
			
			if doesFileExist assetFile == true then
			(
				vers = assetsList[sel].lastVersion
				assetName = assetsList[sel].name
				wipFolder = assetsList[sel].wipFolder
				
				wipFile = wipFolder + "\\" + assetName +"_" + returnDigit vers + "_" + "wip" + "_" + (localTimeStr()) + "_00.max"
				print assetFile
				print wipFile
				
				print "start copy"
				test = copyFile assetFile wipFile
				if test == true then
				(
					print "wip copy done"
					
		-- 			checkForSave() 
					res = checkForSave() 
					
		-- 			loadMaxFile assetFile
					loadMaxFile wipFile
					
-- 					if  res != 3 then
-- 					(
-- 						loadMaxFile wipFile
-- 					)
				)
				else print "wip copy fail"
			)

			else
			(
				print "can't find file"
			)
		)
		else
		(
			print "uncorrect filename"
		)
		
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
		assetName = asset.name
-- 		assetFilename =  asset.lastVersionFile
		relAssetFilename =  root + asset.relVersPath
		
		print assetFilename
		print relAssetFilename
		
		res = mergeMAXFile relAssetFilename   #select #autoRenameDups #renameMtlDups
		
		if res == true then
		(
			sel = selection as array
			assetCtrl = point name: (uniquename assetName)  size: 200
			
			mergedElts = #()
			for o in sel do
			(
				if classof o == vraysun then delete o
				else if classof o == vrayplane then delete o
				else o.parent = assetCtrl
			)
		)
	)
)


-- try(destroyDialog assetEditorRLT)catch()
try(closeRolloutFloater  rof)catch()
rof= newrolloutfloater "Asset Editor" 400 400
addrollout assetEditorRLT rof
-- createdialog assetEditorRLT width: 200

