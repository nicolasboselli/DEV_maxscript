filein "assetManagerDef.ms"

/*
####### struct assetCreationClass 
maj:	
	-- trier les methodes de découpage et de reconstruction des pathname et les variables inutiles
		-- verifier qu'elles ne sont pas utiliser dans assetopener au merge ou à l'affichage ou dans l'assetupdater

	-- dev init for display and init for publishing(?)
	
	-- distinguer ou unifier les variables "version" et "lastversion"
	
	-- comparé les "assetname" et les "version" obtenus à partir des fichier ini et à partir des filename et folder
	
	-- rebuild des methodes d'enregistrements:
		-- respecter la forme suivante: basename.task.publish version.wip.wipversion
		
	--  proposer un rename en fonction du nom de l'asset au merge
	
####### AssetCreation  Rollout:
maj:
	-- blinder le choix de la version d'enregistrement:
		-- prendre en compte la verion de max utiliser
		-- proposer des version d'enregistremnt possible(précédente)
		-- prendre en compte l'exception de max 2017 qui ne supporte pas la saveasversion: 2017
			
	-- proposer un clean des calques et des materiaux avant publish
	-- porposer un rename des calques et des materiaux avant publish
		
	-- re rendre le status editable
	-- prendre en charge les category/task (modelisation, setup, animation)

debug:
	-- au fail de creation d'asset, supprimer le dossier créé

rebuild:
	-- initialiser la creation d'asset à partir d'un fichier ini virtuel
	-- distinguer la methode de creation et de publish  d'asset en fonction de la version créée: 000 == creation , > 0 == publish
	-- developper les trois methode de build de l'asset existant:
		-- à partir des information du fichier ini
		-- à partir du découpage du filename ini
		-- à partir du scan du dossier du fichier ini

	/- fuse  "fn checkCreationSanity", "fn refreshPublishRlt" et "completeparam"
		-- la methode "checkCreationSanity" sert pour la creation d'asset, la methode "refreshPublishRlt" sert pour le publish, complete param complete le rollout
		-- move asset sanity check in the structure
		-- distinguer le sanity check de l'update de l'ui

doc:
	-- à la creationd'asset, l'asset folder est determiné par le basefolder + asset name
	-- au publish d'asset on récupère directement l'asset folder à partir du fichier max

*/ 
 
-- 	structure
struct assetCreationClass 
(
	objs,
	basefolder,
	assetName,
	version,
	
	assetInfo,
	assetFolder, 

	lastVersion,
	
-- 	root,

-- 	wipFolder,
	
	versionInfo,
	lastVersionFile,
	
-- 	relVersPath,
	
	status = "wip",
	
	task,
	
	maxVers,
	
	fn publishInfo =
	(
		format "\nassetName: %\nobjs: %\nbasefolder:%\nversion: %\nassetInfo: %\nassetFolder: %\nlastVersion: %\nroot: %\nwipFolder:%\nversionInfo: %\nlastVersionFile: %\nrelVersPath: %\nstatus: %\nmaxVers: %\n" \
		assetName objs basefolder version assetInfo assetFolder lastVersion root wipFolder versionInfo lastVersionFile relVersPath status maxVers
	),

	fn initFromScene assetRepo =
	(
		basefolder = assetRepo + "\\"
		assetName = getFilenameFile maxFileName
		assetFolder = basefolder + assetName
		version = 0
		lastVersion = 0
		
		publishInfo()
	),
	
	fn initFromSel sel assetRepo =
	(
		objs = sel
		basefolder = assetRepo + "\\"
		assetName = sel[1].name
		assetFolder = basefolder + assetName
		version = 0
		lastVersion = 0
		
	),
	
-- 	fn initFromIni iniFile assetRepo =
	fn initFromIni iniFile  =
	(
		assetInfo = iniFile
		assetFolder = cleanFilename (getFilenamePath assetInfo)
		
		basefolder = getupperfolder (assetFolder) + "\\"
		
		-- get asset name from file ini
		assetName = getINISetting iniFile "assetProperties" "name"
		if assetName.count == 0 then assetName = getINISetting iniFile "assetProperties" "assetName"
		
		-- get last version from file ini
		lastVersion = (getINISetting iniFile "assetProperties" "version") as integer
		version = lastVersion
		
		-- get last version file
-- 		lastVersionFile = cleanFilename(assetFolder + "\\" + (returnDigit lastVersion) +"\\" + assetName + ".max")
		
-- 		publishInfo()
	),
	
-- 	fn getAssetFolder = basefolder +  assetName,
	
-- 	fn getWipFolder = getAssetFolder() + "\\" + "wip",	

-- 	fn getVersionFolder = getAssetFolder() + "\\" + (returnDigit version), 
	
-- 	fn getVersionFile = cleanFilename(assetfolder + "\\" + (returnDigit version) + "\\" + assetName + ".max"),
-- 	fn getWipFile = getWipFolder() + "\\" + assetName +"_" + (returnDigit version) + "_" + "wip" + "_" + (localTimeStr()) + "_v00.max",
	
	fn getWipFolder = assetFolder + "\\" + "wip",	
	fn getVersionFolder = assetfolder + "\\" + (returnDigit version), 	
	fn getWipFile = cleanFilename(getWipFolder() + "\\" + assetName +"." + (returnDigit version) + ".wip.v001.max"),
	
	fn getLastVersionFile = cleanFilename(assetFolder + "\\" + (returnDigit lastVersion) + "\\" + assetName + ".max"),
	
	fn getLatestFile =
	(
		-- collecte des dossiers
		local dirArr = GetDirectories (assetFolder + "\\*")
		
		for d in dirArr do
		(
			join dirArr (getDirectories (d + "\\*"))
		)
		
		append dirArr (assetFolder + "\\")
-- 		for d in dirArr do format "dirArr: %\n" d

		-- collecte des fichier max
-- 		local maxFilesAr = #()
		local maxVal = 0
		local lastestMax
		
		for dir in dirArr do
		(
			local fileArr = getFiles (dir + "*.max")
			if fileArr.count> 0 do
			(
				for f in fileArr do
				(
-- 					format "f: % , filetime:%\n" f (filetime f)
					if (fileTime f) > maxVal then
					(
						lastestMax = f
						maxVal = fileTime f  
					)
-- 					 append maxFilesAr f
				)
			)
		)
		lastestMax
	),
	
	fn createFolders =
	(
		versionFolder = makedir (getVersionFolder()) all: true
		format "version folder: %\n " versionFolder
			
		folderCreated = makedir (getWipFolder())
		format "wip folder: %\n" folderCreated
			
		folderCreated
	),
	
	fn createAssetFileInfo =
	(
-- 		assetInfoIniFile = getAssetFolder() + "\\assetInfo.ini"
		local assetInfoIniFile = assetFolder + "\\assetInfo.ini"
		
		setINISetting assetInfoIniFile "assetProperties" "assetName" assetName
-- 			setINISetting assetInfoIniFile "assetProperties" "path" (getAssetFolder())
-- 			setINISetting assetInfoIniFile "assetProperties" "lastVersion" (version as string)
		setINISetting assetInfoIniFile "assetProperties" "version" (version as string)
	),
	
	fn createVersionFileInfo =
	(
		versionInfoIniFile =  assetFolder +  "\\" + (returnDigit version) + "\\versionInfo.ini"
		
		setINISetting versionInfoIniFile "assetProperties" "name" assetName
		setINISetting versionInfoIniFile "assetProperties" "lastVersion" (version as string)
		setINISetting versionInfoIniFile "assetProperties" "status" status
	),
	
	fn updateAssetFileInfo =
	(
		setINIsetting assetInfo "assetProperties" "version" (lastVersion as string)
	),
	
	fn createAssetFromScene  =
	(
		res = createFolders()
		if res == true then
		(
			local newFile = getLastVersionFile()
-- 			print newFile
			saveMaxFile newFile useNewFile: false
			if doesfileexist newFile then
			(
				createAssetFileInfo()
				createVersionFileInfo()
				format "New Asset Created: %\n"	newFile	
			)
		)
		else format "folders are not existing\n"
	),
	
	fn createAssetFromSel =
	(
		res = createFolders()
		if res == true then
		(
			newFile = getLastVersionFile()
-- 			print newFile
			saveNodes objs newFile
			if doesfileexist newFile then
			(
				createAssetFileInfo()
				createVersionFileInfo()
				format "New Asset Created: %\n"	newFile	
			)
		)
		else format "folders are not existing\n"
	),
	
	fn createWipFile  =
	(
-- 		format "base folder: %\n"	basefolder	
-- 		local lastVersionFile = getLastVersionFile()
		local sourceTmp = getLastVersionFile()
		
-- 		format "last file: %\n"	lastVersionFile	
-- 		local wipFile = getWipFile()
		local destTmp = getWipFile()
		
-- 		format "Wip file: %\n"	wipFile	
-- 		copyFile lastVersionFile wipFile
		
		copyFile sourceTmp destTmp
		
-- 		saveMaxFile wipFile useNewFile: useWipAsset
-- 		format "Wip Created: %\n"	wipFile
-- 		wipFile
		
		destTmp
	),
	
	fn publishNewVersion maxVers =
	(
		-- create new version folder
		local newFolder =  assetFolder +"\\" +  (returnDigit (lastVersion + 1))
		local folderCreated = makedir newFolder all: true
			
-- 		format "newFolder: % folderCreated: %\n" newFolder folderCreated
		
		if maxVers == 2017 then maxVers = 0
			
		-- save new version file
		local newFile
		local newfileCreated
-- 		format "maxvers: %\n" maxVers
		
		if folderCreated == true then
		(
-- 			maxVers = 2015
			local newFile =  newFolder + "\\" +  assetName + ".max" 
			local newfileCreated = saveMaxFile newFile useNewFile: false saveAsVersion: maxVers
			
			if newfileCreated then
			(
				format "Asset Publishing Done: % ; New Version Published: % \n" assetName newFile
			)
			else
			(
				format "Asset Publishing Fail: % \n" assetName
			)
		)

		
		if newfileCreated then
		(
			 lastVersion =  lastVersion + 1
-- 			 lastVersionFile = newFile
			
			-- update asset info file
			 updateAssetFileInfo()
			
			-- create version info file
			 createVersionFileInfo()
		)
		else
		(
-- 			delete folder si echec
		)
		
-- 		format "publishing method end: %\n" newFile
		newFile
	),
	

	
	fn getMaxFileVersion = 
	(
		local maxVers
		res = getMaxFileVersionData (getLastVersionFile())
		if res[1] == 14000 then maxVers = "2012"
		else if res[1] == 15000 then maxVers = "2013"
		else if res[1] == 16000 then maxVers = "2014"
		else if res[1] == 17000 then maxVers = "2015"
		else if res[1] == 18000 then maxVers = "2016"
		else if res[1] == 19000 then maxVers = "2017"
		else maxVers = "unknow"
		
		maxVers
	),
	
	fn countInstNumInScene =
	(
		local instanceNumAr = #()
		local instanceCount = 0
		local maxNum = 0
		
		for h in helpers where getUserProp h "assetName" == assetName do
		(
			instanceCount +=1
			if instanceCount > maxNum then maxNum = instanceCount
	-- 		format "instanceCount: % \n"  instanceCount
			
			numTmp = getUserProp h "instanceNum" --  as integer
			
			if (classof numTmp) == integer then
			(
				if numTmp > maxNum then maxNum = numTmp
			)
		)
		format "maxNum: %\n" (maxNum)
		maxNum
	),
	
	fn mergeAsset3 mergeAsAsset: true ignoreVrSet: false ignoreCacheLay: false objsNameConflict: #AutoRenameDups instNum: 1 =
	(
		
		local assetCtrl
		-- create asset point
		if mergeAsAsset then 
		(
			LM = layermanager
			local ctrlName = assetName + "_"+  (instNum as string) + "_CTRL"
			assetCtrl = point name: ctrlName size: 200
			assetsLayer = LM.getLayerFromName "assets_layer"
			
			if assetsLayer == undefined do assetsLayer = LM.newLayerFromName "assets_layer"
			
			assetsLayer.addnode assetCtrl
			
			-- tag de l'asset point
			setUserProp assetCtrl "asset" true
			
			setUserProp assetCtrl "assetfolder" assetFolder
			
			setUserProp assetCtrl "assetName"  assetName
			setUserProp assetCtrl "assetVersion" lastVersion
			
			setUserProp assetCtrl "instanceNum" instNum
			
			format "instNum merge:%\n" instNum
			
			-- useless
			/*
			setUserProp assetCtrl "root" root
			setUserProp assetCtrl "relativePath" relVersPath
			
			setUserProp assetCtrl "allAssetsRoot" allAssetsRoot
			setUserProp assetCtrl "allAssetsFolder" allAssetsFolder
			setUserProp assetCtrl "relativeFolder" relativeFolder
			setUserProp assetCtrl "relativeFolder2" relativeFolder2
			*/
			
		)
		
		local objsCountBef = objects.count
		--import
		local f = getLastVersionFile()
		mergeMAXFile f  #useSceneMtlDups  objsNameConflict -- #AutoRenameDups  -- #mergeDups -- #select
		
	--	collect objects import
		objsImpAr = #()
		if objects.count > objsCountBef do
		(
			objsImpAr = for i = (objsCountBef + 1) to objects.count collect objects[i]
		)
		
	-- actions sur les objets importés
		for o in objsImpAr do
		(
			if not isValidNode o do continue
				
	-- 		o = getnodebyname str
			local deletion = false
			
			-- suppresion des elemets vray
			local belongToVrSet = false
			if classof o == vraysun or classof o == vrayplane or  classof o == targetcamera then belongToVrSet = true
			if ignoreVrSet and belongToVrSet  then deletion = true

			-- suppression des elements caches
			belongToCachLay = matchpattern o.layer.name pattern: "*cache_layer*"	
			if ignoreCacheLay and belongToCachLay then deletion = true
			
			-- parenter au ctrl asset
			if mergeAsAsset and  o.parent == undefined and not isGroupMember o then o.parent = assetCtrl
			else if mergeAsAsset and o.parent == undefined and isGroupHead o then o.parent = assetCtrl
			
			format "obj: %, deletion:%, parent:%\n" o.name deletion o.parent
			
			if deletion == true then delete o
			
			-- rename des objets de l'asset
			o.name = substitutestring o.name (assetName + "_") ""
			o.name = substitutestring o.name ((instNum as string) + "_") ""
			
			o.name = assetName + "_" + (instNum as string) + "_" + o.name
			
			-- rename des layer
		)
	
		assetCtrl		
	)
	
)


try(destroyDialog createAssetRLT)catch()
rollout createAssetRLT "create asset v3" 
(
	local armadasScriptsIni = (GetDir #maxData) + "armadasScriptsIni.ini"
-- 	vars
	local allAssetsFolder
	local root
	
-- 	local assetPath = @"\\ELVIS\_svn\zz_ressources3D"
	local newAsset
	
	local mode
	
	local creationSanity = false
	local publishSanity = false
	
	
	group "parameters"
	(
		edittext pathET "base path:" readonly: true
		
		edittext nameET "name:" enabled: false across: 2
		edittext versionET "version:" enabled: false readonly: true
		
		edittext statusET "status:" enabled: false across: 3
		edittext commentET "comment:"  enabled: false
		dropdownlist maxVersDL "max vers:" items: #( "2015", "2017") selection: 2 width: 60
	)
	
	group "asset sanity checking from scene:"
	(
-- 		button checkCreationBT "sanity check" 
		
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
		edittext publishingSanityET "publishing ready" readonly: true
	)
	
	group "asset creation :"
	(
		checkbox useWipCB "use wip asset created" state: false across: 3 enabled: false
		button createAssetBT2 "create version" enabled: false 
	)
	
	-- functions ui dependant 
	-- check avant la creation d'assset
	fn checkCreationSanity newAsset =
	(
-- 		local creationSanity = false
		
		local correctName = false
		local assetFolderExists = false
		local versionFolderExists = false
		local versionFileExists = false
		local assetFileInfoExists = false
		
		-- check name
		if newAsset.assetName.count > 0 then correctName = true else correctName = false
			
		-- check asset folder exists
-- 		res = getDirectories (newAsset.getAssetFolder())
		res = getDirectories (newAsset.assetFolder)
		if res.count != 1 then assetFolderExists = false else assetFolderExists = true
			
		-- check version folder exists
		res = getDirectories (newAsset.getVersionFolder())
		if res.count != 1 then versionFolderExists = false else versionFolderExists = true
		
		-- check wip folder exists
		
		-- check version file exists
		res = getfiles (newAsset.getLastVersionFile())
		if res.count != 1 then versionFileExists = false else versionFileExists = true
			
		-- check asset info file exists
-- 		res = getfiles (newAsset.basefolder + "\\assetInfo.ini" )
		res = getfiles (newAsset.assetFolder + "\\assetInfo.ini" )
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
-- 			publishSanity = false
		)
		else 
		(
			creationSanity = false
-- 			publishSanity = true
		)		
	)
	
	-- check avant le publish
	fn refreshPublishRlt asset =
	(
		format "start publishing refresh\n"
		-- test if asset folder ready
		local nameOk = False
		local nextVersionPossible = False
		
		-- check asset info file exists
-- 		local assetFileInfoExists = doesfileexist (asset.assetInfo)
		local assetFileInfoExists = doesfileexist (asset.assetfolder +"//"+ "assetinfo.ini")
		
		-- COMPARE NOM
		--  determiner le nom de l'asset depuis l enom du fichier max
		local currentFile = maxFilePath
		local currentFileName = undefined
		
		if currentFile.count > 0 then
		(
			basefolder = getUpperFolder currentFile
			pathAr = filterString  basefolder "\\"
			currentFileName = pathAr[pathAr.count]
		)
		
		-- compare le nom de l'asset determiné à partir du fichier avec le nom de l'asset déterminé à partir du fichier ini		
		if currentFileName == asset.assetName then nameOk = true	else ()
		
		-- COMPARE VERSION
		--  détermine le nombre de version en comptant les dossiers
		local lastVersion = 0
		local folderVersion = False
		local assetFolders = getDirectories (asset.assetFolder + "\*")
		
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
		
		-- compare la version de l'asset determiné à partir du comptage des dossier asset la version déterminé à partir du fichier ini	
		if folderVersion == true do
		(
			if asset.lastVersion == lastVersion then
			(
-- 				versionText = returnDigit (lastVersion + 1)
				nextVersionPossible = true
			)
		)
		
		-- update du rollout
		if  assetFileInfoExists == true and	nameOk == true  and nextVersionPossible == true then
		(
			publishSanity = true
		)
		else publishSanity = false

		format "end publishing refresh\n"
	)
	
-- 	fn completeParam asset =
	fn RefreshUI =
	(
-- 		pathET.text = asset.basefolder
		pathET.text = newAsset.basefolder
		pathET.enabled = true
		
		nameET.text = newAsset.assetName
		nameET.enabled = true

		versionET.text = returnDigit newAsset.version
		versionET.enabled = true
		
		versResET.text = newAsset.getLastVersionFile()
		wipResET.text = newAsset.getWipFile()
		
		creationSanityET.text = creationSanity as string
		publishingSanityET.text = creationSanity as string
		
-- 		format "creationSanityTest: %, publishSanity: %\n" creationSanity publishSanity
		creationSanityET.text = creationSanity as string
		publishingSanityET.text = publishSanity as string
		
-- 		if publishSanity then nameET.readonly = true else nameET.readonly = false
		
		if creationSanity or publishSanity then
		(
			createAssetBT2.enabled = true
			useWipCB.enabled = true
		)
		else
		(
			createAssetBT2.enabled = false
			useWipCB.enabled = false
		)

	)
	
	fn initForScene =
	(
		mode = 1
		createAssetBT2.caption = "create asset from scene"
		createAssetRLT.title = "create asset from scene"
		
		local rootIni = getINISetting armadasScriptsIni "assetManager" "repositoryPath"
		
		if rootIni.count > 0 then
		(
			if doesfileexist rootIni == true then root = rootIni + "\\"
				
			newAsset = assetCreationClass()
			newAsset.initFromScene root
				
			checkCreationSanity newAsset
			RefreshUI()	
			format "newAsset: % \n" newAsset
		)
	)
	
	fn initForSelection =
	(
		mode = 2
		sel = selection as array
		createAssetBT2.caption = "create asset from selection"
		createAssetRLT.title = "create asset from selection"
		
		local rootIni = getINISetting armadasScriptsIni "assetManager" "repositoryPath"
		
		if rootIni.count > 0 and sel.count > 0 then
		(
-- 			print "youpi!"
			if doesfileexist rootIni == true then root = rootIni + "\\"
			
			newAsset = assetCreationClass()
			newAsset.initFromSel sel root
-- 			print newAsset
			
			
			checkCreationSanity newAsset
			RefreshUI()		
			format "newAsset: % \n" newAsset
		)
	)
	
	fn initForPublishing =
	(
		mode = 3
		createAssetBT2.caption = "publish new asset version"
		createAssetRLT.title = "publish new asset version"
		
		-- check if we are in asset
		infoTest = (getUpperFolder maxFilePath) + "assetInfo.ini"
			-- find assetInfo.ini file
		local res = doesfileexist infoTest 
		
		local rootIni = getINISetting armadasScriptsIni "assetManager" "repositoryPath"
		
		if rootIni.count > 0 and res then
		(
			if doesfileexist rootIni == true then root = rootIni + "\\"
				
			newAsset = assetCreationClass()
			newAsset.initFromIni infoTest --root
			newAsset.version += 1
			
			
			refreshPublishRlt newAsset
			RefreshUI()		
-- 			checkCreationSanity newAsset
		)
		else (print "this is not an asset")
	)
	-- Actions
	
	on createAssetRLT open do
	(
		if not assetEditorRLT.assetOp == undefined then
		(
			format "asset op: %\n" assetEditorRLT.assetOp
			if assetEditorRLT.assetOp == 1 then
			(
				initForScene()
			)
			else if assetEditorRLT.assetOp == 2 then
			(
				initForSelection ()
			)
			else if assetEditorRLT.assetOp == 3 then
			(
				initForPublishing ()
			)
			else()
		)
		else
		(
			format "assetOp error\n"
			try(destroyDialog createAssetRLT)catch()
		)
	)
	
	on nameET entered str do
	(
		if newAsset != undefined then
		(
			print "check1"
			newAsset.assetName =  str
			newAsset.assetFolder =  newAsset.basefolder + newAsset.assetName
			print "check2"
			newAsset.publishInfo()
			print "check3"
			refreshPublishRlt newAsset
			print "check4"
			checkCreationSanity newAsset
			print "check5"
			RefreshUI()
			print "check6"
-- 			newAsset.publishInfo()
		)
	)

	
	on createAssetBT2 pressed do
	(
		if mode == 1 then newAsset.createAssetFromScene()
		else if mode == 2 then newAsset.createAssetFromSel()
		else if mode == 3 then 
		(
			local maxVers
-- 			if maxVersDL.selection == 1 then maxVers = 2015 else if  maxVersDL.selection == 2 then maxVers = 2017
			maxVers = maxVersDL.selected  as integer
			format "max version: %\n" maxVers
			newAsset.publishNewVersion maxVers
		)
			
		if useWipCB.state then
		(
			local wipFile = newAsset.createWipFile()
			if checkForSave() do loadMaxFile wipFile useFileUnits: true
		)
		
		format "asset creation done: %\n" newAsset.assetName
-- 		try rof.rollouts[2].refreshFromOutside() catch(format "*** % ***\n" (getCurrentException()))
		destroydialog createAssetRLT
	)
)
-- createdialog createAssetRLT width: 800

-- f = @"T:\CA Immobilier\Amphion les Bains_1117\Perspectives\Scenes 3d\modelisation\wip\batB\assetInfo.ini"
-- doesfileexist f
-- getFileCreateDate  f

-- fileTime f

-- test = assetCreationClass()
-- test.initFromIni f

-- test.getLastVersionFile()
-- test.getLatestFile()