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
	print assetsAr
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
		listbox assetsLB "assets:"
		edittext assetET "asset version:" readonly: true
		edittext currentVersionET "current version:" readonly: true
		edittext lastVersionET "is last version:" readonly: true
		edittext nextVersionET "next version file:" readonly: true
		button updateAssetBT "update asset" enabled: false
	)
	
-- 	actions
	on vrmeshesRemapRLT open do
	(
		vrMeshesAr = collectVrmeshesInScene()
		vrmeshesLB.items = for o in vrMeshesAr collect o.filename
			
		assetAr = collectAssetInScene()
		
		for o in assetAr do
		(
			try
			(
				print "start asset creation"
				newAsset = assetInScene()
				newAsset.initFromCtrl o
				append assetClassAr newAsset
				print "asset creation done"
			)catch(format "*** % ***\n" (getCurrentException()))
		)
		assetsLB.items = for o in assetClassAr collect o.name
	)
	
	on assetsLB selected sel do
	(
		select assetClassAr[sel].obj
		
		assetET.text = assetClassAr[sel].versionFile
		currentVersionET.text =returnDigit (assetClassAr[sel].version as integer)
		lastVersionET.text = assetClassAr[sel].islastVersion as string
		
		if assetClassAr[sel].islastVersion == false then
		(
			updateAssetBT.enabled = true
			nextVersionET.text = assetClassAr[sel].lastVersionFile
		)
		else 
		(
			updateAssetBT.enabled = false
			nextVersionET.text = "NONE"
		)
	)
	
	
	on updateAssetBT pressed do
	(
		oldCtrl = assetAr[assetsLB.selection]
		
		assetToUp = assetClassAr[assetsLB.selection]
		newAssetCtrl = assetToUp.updateAsset()

		objToDel = returnAllHierarchyDown #(oldCtrl)
		delete objToDel
		select newAssetCtrl
	)


)

createdialog vrmeshesRemapRLT width: 800