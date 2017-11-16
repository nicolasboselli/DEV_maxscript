/*
maj:
	-- (asset explorer: update tools v2)
	-- prendre en charge les asset node
		-- checker les asset node de la scene
		-- compter les instances
		-- importer le nouvel asset
		-- si l'import est intance d'un asset:  renommer la nouvelle instance en numerotant aprés le basename
	
	-- effectuer un rename à l'update qui preserve le nom du merge
	
	-- fonction pour dupliquer l'asset en renomant correctement

	-- proposer la préservation des materiaux des objects à l'update
	-- proposer la préservation des postion des objects à l'update
	-- préserver les noms à l'update
		
rebuild:
	--  trier les variables et methodes inutiles
	-- utiliser la structure asset generale pour l'update
*/


filein "assetManagerDef.ms"


fn collectAssetInScene =
( 
	for h in helpers where classof h == point and getUserProp h "asset" collect h
)

fn collectAssetNames =
(
	local assetNamesAr = #()
	for h in helpers where getUserProp h "asset" do
	(
		appendifunique assetNamesAr (getUserProp h "assetName")
	)
	assetNamesAr
)
-- collectAssetNames()


fn returnMaxAssetCount assetName =
(
	local instanceNumAr = #()
	local instanceCount = 0
	local maxNum = 0
	
	for h in helpers where getUserProp h "assetName" == assetName do
	(
		instanceCount +=1
		
		numTmp = getUserProp h "instanceNum" --  as integer
		format "numTmp: %, classof: % \n" numTmp (classof numTmp)
		if (classof numTmp) == integer then
		(
			if numTmp > maxNum then maxNum = numTmp
		)
	)
	instanceCount
)

struct assetGroup
(
	assetName,
	assetInstances = #(),
	fn initAssetGroup = 
	(
		assetInstances = for h in helpers where getUserProp h "assetName" == assetName collect h 
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
	
	/*
	allAssetsRoot,
	allAssetsFolder,
	relativeFolder,
	relativeFolder2,
	*/
	
	fn publishInfo =
	(
		format "name:% , version:% , assetFolder:% \n" name version assetFolder
	),
	
	fn initFromCtrl oneCtrl=
	(
		obj = oneCtrl
		
		name = getuserprop obj "assetName"
		version = getuserprop obj "assetVersion"
		assetFolder = getuserprop obj "assetfolder"
		
		/*
		allAssetsRoot = getuserprop obj "allAssetsRoot"
		allAssetsFolder = getuserprop obj "allAssetsFolder"
		relativeFolder = getuserprop obj "relativeFolder"
		relativeFolder2 = getuserprop obj "relativeFolder2"
		*/
		
		-- obsolete root and relativePath
		root = getuserprop obj "root"
-- 		versionFile = root + (getuserprop obj "relativePath")
		versionFile = cleanFilename(assetFolder + "\\" + (returnDigit version) + "\\" + name + ".max")

		-- check last version
		if assetFolder.count == 0 then assetFolder = getupperfolder(getFilenamePath  versionFile)
		assetIni = assetFolder + "assetInfo.ini"

		lastVersion = (getINISetting assetIni "assetProperties" "version") as integer
		lastVersionFile = cleanFilename(assetFolder + "\\" +(returnDigit lastVersion) + "\\" + name + ".max")

		isLastVersion = true
		if lastVersion > version and doesfileexist lastVersionFile ==  true then isLastVersion = false

	-- 		relVersPath = relativeFolder + (returnDigit lastVersion) +"\\" + name + ".max"
-- 		publishInfo()
	),
	
	fn updateAsset =
	(
-- 		newAsset = assetClass()
		newAsset = assetCreationClass()
		newAsset.initFromIni assetIni allAssetsFolder
-- 		newAssetCtrl = newAsset.mergeAsset ignoreCache: true
		newAssetCtrl = newAsset.mergeAsset3 mergeAsAsset: true ignoreVrSet: false ignoreCacheLay: true
		newAssetCtrl.transform = obj.transform
		newAssetCtrl
	)
)


try(destroyDialog updateAssetsToolRLT)catch()

rollout updateAssetsToolRLT "update assets tool v.2"
(
	
-- 	vars
	local allAssetsFolder 
	local root 
	
-- 	local vrMeshesAr = #()
	local assetAr = #()
	local assetClassAr = #()
	local assetClassArToShow = #()
	
-- 	ui
	/*
	edittext allAssetsFolderET "all assets folder:" text: allAssetsFolder readonly: true
	edittext rootET "root:" text: root readonly: true
	button collectAssetBT "collect assets"
	*/
	

	
	group "assets to update:"
	(
		checkbox outOfDateOnlyCB "display out of date assets only"
		multiListBox  assetsLB "assets:"
		edittext assetET "asset version:" readonly: true
		edittext currentVersionET "current version:" readonly: true
		edittext lastVersionET "is last version:" readonly: true
		edittext nextVersionET "next version file:" readonly: true
		edittext assetCtrlET "asset ctrl:" readonly: true
		button updateAssetBT "update asset" enabled: false across: 2
		button duplicateAssetBT "duplicate asset" enabled: true
	)
	
	-- ui fonctions relatives
		-- asset collect
	fn updateAssetArray =
	(	
		assetClassAr = #()
		assetAr = collectAssetInScene()
		
		for o in assetAr do
		(
			try
			(
-- 				print "start asset creation"
				newAsset = assetInScene()
				newAsset.initFromCtrl o
				format "asset updated: %\n" newAsset
				append assetClassAr newAsset
-- 				print "asset creation done"
			)catch(format "*** % ***\n" (getCurrentException()))
		)
	)
	
	fn refreshAssetUI =
	(
		assetClassArToShow = #()
		 
		for o in assetClassAr do
		(
			if outOfDateOnlyCB.state == true then
			(
				if o.isLastVersion == false then
				(
					append assetClassArToShow o
				)
			)
			else
			(
				append assetClassArToShow o
			)
			
		)
		assetsLB.items = for o in assetClassArToShow collect o.name
	)
	
-- 	actions
	on outOfDateOnlyCB changed state do refreshAssetUI()
	
	on updateAssetsToolRLT open do
	(
		-- asset collect
		updateAssetArray()
		refreshAssetUI()
	)
	
	
	on assetsLB selectionEnd do
	(
		selIdAr = assetsLB.selection as array
		clearselection()
		
		for id in selIdAr do
		(
			selectmore assetClassArToShow[id].obj
			
			assetET.text = assetClassArToShow[id].versionFile
			currentVersionET.text =returnDigit (assetClassArToShow[id].version as integer)
			lastVersionET.text = assetClassArToShow[id].islastVersion as string
			assetCtrlET.text = assetClassArToShow[id].obj.name
			
			if assetClassArToShow[id].islastVersion == false then
			(
				updateAssetBT.enabled = true
				nextVersionET.text = assetClassArToShow[id].lastVersionFile
			)
			else 
			(
				updateAssetBT.enabled = true
				nextVersionET.text = "NONE"
			)
		)
	)
	
	on updateAssetBT pressed do
	(
		idAr = assetsLB.selection as array
		
		for id in idAr do
		(

			oldCtrl = assetClassArToShow[id].obj
			
			assetToUp = assetClassArToShow[id]
			
			newAssetCtrl = assetToUp.updateAsset()

			objToDel = returnAllHierarchyDown #(oldCtrl)

			delete objToDel
		
			select newAssetCtrl
			
		)
		
		updateAssetArray()
		refreshAssetUI()
	)
	
	on duplicateAssetBT pressed do
	(
		-- collecte asset id
		
		
		local newAssetAr = #()
		local newAsset =#()
		local selIds = assetsLB.selection
		
		for id in selIds do
		(
			
			local newAssetNumber = returnMaxAssetCount assetClassArToShow[id].obj.name
			format "asset: %, count: %\n" assetClassArToShow[id].obj.name newAssetNumber
			local objsToDup = returnAllHierarchyDown #(assetClassArToShow[id].obj)
-- 			select objsToDup
			maxOps.CloneNodes objsToDup newNodes: &newAssetObjs
-- 			format "newAsset: %\n" newAsset
-- 			for n in newAsset do append newAssetAr n
		)
-- 		select newAssetAr
		
		updateAssetArray()
		refreshAssetUI()
	)
)

createdialog updateAssetsToolRLT width: 800



-- maxOps.CloneNodes $ newNodes:&newAsset
-- select newAsset
