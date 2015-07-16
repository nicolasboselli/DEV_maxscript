filein "assetManagerDef.ms"

/*
maj:
	-- add button for init root base path folder and choose base path folder in parameters base path
	-- create info files and check it
	-- check version
	-- move asset sanity check in the structure

bug:
	-- confond filename with folder name
*/


-- 	structure
struct assetFromSelClass
(
	objs,
	basefolder,
	name,
	version,
	
	fn initFromSel sel =
	(
		objs = sel
		basefolder = getUpperFolder maxFilePath
		name = sel[1].name
		version = 0
	),
	
	fn getAssetFolder = basefolder +  name,
	
	fn getVersionFolder = getAssetFolder() + "\\" + (returnDigit version),
	
	fn getWipFolder = getAssetFolder() + "\\" + "wip",
	
	fn getVersionFile = getVersionFolder() + "\\" + name + ".max",
	
-- 		fn getWipFile = getWipFolder() + "\\" + name + "_wip_" + ".max",

	fn getWipFile = getWipFolder() + "\\" + name +"_" + (returnDigit version) + "_" + "wip" + "_" + (localTimeStr()) + "_00.max",
		
	fn createFolders =
	(
		versionFolder = makedir (getVersionFolder()) all: true
		print ("version folder: " + (versionFolder as string))
			
		folderCreated = makedir (getWipFolder())
		print ("wip folder: " + (folderCreated as string))
			
		folderCreated
	),
	
	fn createAssetFileInfo =
	(
		assetInfoIniFile = getAssetFolder() + "\\assetInfo.ini"
		assetInfoFileStream = createFile assetInfoIniFile
		close assetInfoFileStream
		
		setINISetting assetInfoIniFile "assetProperties" "name" name
-- 			setINISetting assetInfoIniFile "assetProperties" "path" (getAssetFolder())
-- 			setINISetting assetInfoIniFile "assetProperties" "lastVersion" (version as string)
		setINISetting assetInfoIniFile "assetProperties" "version" (version as string)
		
	),
	
	fn createVersionFileInfo =
	(
		versionInfoIniFile = getVersionFolder() + "\\versionInfo.ini"
		versionInfoFileStream = createFile versionInfoIniFile
		close versionInfoFileStream
		
		setINISetting versionInfoIniFile "assetProperties" "name" name
-- 			setINISetting versionInfoIniFile "assetProperties" "versionFile" (getVersionFile())
		setINISetting versionInfoIniFile "assetProperties" "lastVersion" (version as string)
		
	),
	
	fn createAsset useWipAsset=
	(
		res = createFolders()
		if res == true then
		(
			newFile = getVersionFile()
			print newFile
			saveMaxFile newFile useNewFile: false
			print "version created"
			
			wipFile = getWipFile()
			saveMaxFile wipFile useNewFile: useWipAsset
			print "wip created"
			
			createAssetFileInfo()
			createVersionFileInfo()
		)
		else
		(
			print "folders are not existing"
		)
	),
	
	fn createAssetFromSel useWipAsset =
	(
		res = createFolders()
		if res == true then
		(
			newFile = getVersionFile()
			print newFile
			saveNodes objs newFile
-- 			saveMaxFile newFile useNewFile: false
			print "version created"
			
			if useWipAsset == true then
			(
				wipFile = getWipFile()
				saveNodes objs wipFile
	-- 			saveMaxFile wipFile useNewFile: useWipAsset
				print "wip created"
			)
			
			createAssetFileInfo()
			createVersionFileInfo()
		)
		else
		(
			print "folders are not existing"
		)
	)
	
)
	
	


try(destroyDialog createAssetFromSelRLT)catch()

rollout createAssetFromSelRLT "create asset from selection"
(
-- 	vars
	local allAssetsFolder = "zz_ressources3D"
	local root = @"J:\_svn\zz_ressources3D\"
	
	local newAsset
	
	
	group "parameters"
	(
		button autocompleteBT "Auto-Complete"
		edittext pathET "base path:" readonly: true
		button initPathBT "init path" across: 2
		button openDialogBT "..."
		
		edittext nameET "name:" enabled: false across: 2
		edittext versionET "version:" enabled: false readonly: true
		
		edittext statusET "status:" enabled: false
		edittext superclassET "superclass:" enabled: false
		edittext classET "class:"  enabled: false
		edittext commentET "comment:"  enabled: false
	)
	
	group "asset sanity checking from scene:"
	(
		button checkCreationBT "sanity check" 
		
		edittext correctNameET "correct name:" readonly: true across: 3
		edittext assetFolderCheckET "asset folder exists:" readonly: true
		edittext versionFolderCheckET "version folder exists:" readonly: true 
		edittext wipFolderCheckET "wip folder exists:" readonly: true across: 3
		edittext fileCheckET "file exists:" readonly: true 
		edittext assetFileInfoCheckET "asset info exists:" readonly: true
		edittext versionFileInfoCheckET "version info exists:" readonly: true
	)
	
	group "sanity diagnostic:"
	(
		edittext versResET"version file result:" readonly: true
		edittext wipResET"wip file result:" readonly: true
		edittext creationSanityET "creation ready" readonly: true across: 2
		edittext publishingSanity "publishing ready" readonly: true
	)
	
	group "asset creation from scene :"
	(
		checkbox useWipCB "use wip asset created" state: false across: 3 enabled: false
-- 		button createAssetBT "create asset with scene" enabled: false 
		button createAssetFromSelBT "create asset from selection" enabled: false
	)
	

	
	-- functions ui dependant 
	fn checkCreationSanity newAsset =
	(
		creationSanity = false
		-- check name
		if newAsset.name.count > 0 then correctName = true else correctName = false
			
		-- check asset folder exists
		res = getDirectories (newAsset.getAssetFolder())
		if res.count != 1 then assetFolderExists = false else assetFolderExists = true
			
		-- check version folder exists
		res = getDirectories (newAsset.getVersionFolder())
		if res.count != 1 then versionFolderExists = false else versionFolderExists = true
		
		-- check wip folder exists
		
		-- check version file exists
		res = getfiles (newAsset.getVersionFile())
		if res.count != 1 then versionFileExists = false else versionFileExists = true
			
		-- check asset info file exists
		res = getfiles (newAsset.basefolder + "\\assetInfo.ini" )
		if res.count != 1 then assetFileInfoExists = false else assetFileInfoExists = true
		-- check version info file exists
		
		
		-- checking ui result
		correctNameET.text = correctName as string
		assetFolderCheckET.text = assetFolderExists as string
		versionFolderCheckET.text = versionFolderExists as string
		assetFileInfoCheckET.text = assetFileInfoExists as string
		fileCheckET.text = versionFileExists as string
		
		
		if correctName == true and assetFolderExists == false and versionFolderExists == false and assetFileInfoExists == false then
		(
			creationSanity = true
		)
		
		-- diagnostic ui result
		versResET.text = newAsset.getVersionFile()
		wipResET.text = newAsset.getWipFile()
		
		creationSanityET.text = creationSanity as string
		
		if creationSanity == true then
		(
-- 			createAssetBT.enabled = true
			createAssetFromSelBT.enabled = true
			useWipCB.enabled = true
		)
		else
		(
			createAssetFromSelBT.enabled = false
-- 			createAssetBT.enabled = false
			useWipCB.enabled = false
		)
		
		creationSanity
	)
	
	
	fn completeParam asset =
	(
		pathET.text = asset.basefolder
		pathET.enabled = true
		
		nameET.text = asset.name
		nameET.enabled = true

		versionET.text = returnDigit asset.version
		versionET.enabled = true
	)
	
		
-- 	actions
	on openDialogBT pressed do
	(
		res = getSavePath caption: "chose folder" initialDir: newAsset.basefolder
		if  res != undefined then
		(
			newAsset.basefolder = res + "\\"
			
			completeParam newAsset
			checkCreationSanity newAsset
		)
	) 
	
	on createAssetFromSelRLT open do
	(
		sel = selection as array
		if sel.count >0 then
		(
			newAsset = assetFromSelClass()
			newAsset.initFromSel sel
			print newAsset
			
			completeParam newAsset		
			checkCreationSanity newAsset
		)
	)
	
	on autocompleteBT pressed do
	(
		sel = selection as array
		if sel.count >0 then
		(
			newAsset = assetFromSelClass()
			newAsset.initFromSel sel
			
			completeParam newAsset		
			checkCreationSanity newAsset
		)
	)
	
	on initPathBT pressed do
	(
		newAsset.basefolder = root
		
		completeParam newAsset
		checkCreationSanity newAsset
	)
	
	
	on nameET entered str do
	(
		if newAsset != undefined then
		(
			newAsset.name =  str
			
			completeParam newAsset
			checkCreationSanity newAsset
		)

	)
	
	on checkCreationBT pressed do
	(
		
		if newAsset != undefined then
		(
			checkCreationSanity newAsset
		)
		else
		(
			print "complete fields"
		)
		
	)
	
	on createAssetBT pressed do
	(
		newAsset.createAsset useWipCB.state
		
		-- refresh ui
		newAsset = assetCreationClass()
		newAsset.initFromScene()
		completeParam newAsset		
		checkCreationSanity newAsset
		print "asset creation done"
	)
	
	on createAssetFromSelBT pressed do
	(
		newAsset.createAssetFromSel useWipCB.state
	)
	 
)
createdialog createAssetFromSelRLT width: 800

