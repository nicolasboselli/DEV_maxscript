-- maj:
	-- make multi selection on list
	-- display only out of date assets
		-- make two array
	-- switch

filein "assetManagerDef.ms"
-- vraymeshes remapper

fn collectVrmeshesInScene =
(
	sel = geometry as array
	vrmeshes = for o in sel where classof o == vrayproxy collect o
	vrmeshes	
)

fn collectAssetInScene =
( 
	assetsAr = #()
	pointsAr = for h in helpers where classof h == point collect h
-- 	print pointsAr
	for o in pointsAr do
	(
		test = getUserProp o "asset"
-- 		print(getUserProp o "asset")
		if test == true do 
		(
			append assetsAr o
		)
	)
-- 	print assetsAr
	assetsAr
)


try(destroyDialog vrmeshesRemapRLT)catch()

rollout vrmeshesRemapRLT "asset update tools"
(
	
-- 	vars
	local allAssetsFolder = "zz_ressources3D"
	local root = @"J:\_svn\zz_ressources3D"
	
	local vrMeshesAr = #()
	local assetAr = #()
	local assetClassAr = #()
	local assetClassArToShow = #()
	
-- 	ui
	edittext allAssetsFolderET "all assets folder:" text: allAssetsFolder readonly: true
	edittext rootET "root:" text: root readonly: true
	button collectAssetBT "collect assets"
	
	group "vray proxies:"
	(
		listbox vrmeshesLB "vrmeshes paths:"
	)
	
	group "assets to update:"
	(
		checkbox outOfDateOnlyCB "display out of date assets only"
		multiListBox  assetsLB "assets:"
		edittext assetET "asset version:" readonly: true
		edittext currentVersionET "current version:" readonly: true
		edittext lastVersionET "is last version:" readonly: true
		edittext nextVersionET "next version file:" readonly: true
		button updateAssetBT "update asset" enabled: false
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
	
	on vrmeshesRemapRLT open do
	(
		-- vrmeshes collect
		vrMeshesAr = collectVrmeshesInScene()
		vrmeshesLB.items = for o in vrMeshesAr collect o.filename
		
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
			
			if assetClassArToShow[id].islastVersion == false then
			(
				updateAssetBT.enabled = true
				nextVersionET.text = assetClassArToShow[id].lastVersionFile
			)
			else 
			(
				updateAssetBT.enabled = false
				nextVersionET.text = "NONE"
			)
		)
		
	)
	
	on updateAssetBT pressed do
	(
		print "start update"
-- 		idAr = #(assetsLB.selection)
		idAr = assetsLB.selection as array
		
		
		for id in idAr do
		(
-- 			print assetClassArToShow[id]
			
			oldCtrl = assetClassArToShow[id].obj
-- 			print ( "oldctrl:" + oldCtrl.name)
-- 			select oldCtrl
			
			
			assetToUp = assetClassArToShow[id]
			
			newAssetCtrl = assetToUp.updateAsset()
			
-- 			print "objToDel"
			objToDel = returnAllHierarchyDown #(oldCtrl)
			
			
-- 			print "check2"
			delete objToDel
		
			select newAssetCtrl
			
		)
		
		updateAssetArray()
		refreshAssetUI()
		print "end update"
	)


)

createdialog vrmeshesRemapRLT width: 800