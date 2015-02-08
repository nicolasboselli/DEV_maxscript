global Lmgr = layermanager
global LayerCount = Lmgr.count 

global layername = #()
global LayerVisible = #()
global LayerHidden = #()

global HidLayIdSel
global VisLayIdSel

global LayerHiddenId
global LayerVisibleId

global LayToMayBeSwap

global AllLayerAsset = #()


fn FindHiddenLayFN = 
(

	local FNLayerHidden = #()
	
	for i = 0 to ( layermanager.count - 1) do
	(
		tempLayer = layermanager.getlayer i
		if (tempLayer.ishidden == true) then
		(
			append FNLayerHidden (tempLayer.name)
		)
	)
	
	return FNLayerHidden
)


fn FindHiddenLayIdFN =
(
	local FNLayerHiddenId = #()
	
	for i = 0 to ( layermanager.count - 1) do
	(
		tempLayer = layermanager.getlayer i
		if (tempLayer.ishidden == true) then
		(
			append FNLayerHiddenId i
		)
	)
	
	return FNLayerHiddenId
)



-- LayerHiddenId = FindHiddenLayIdFN ()

-- test = FindHiddenLayFN ()

fn FindVisLayFN =
(
	local FNLayerVisible = #()
	
	for i = 0 to ( layermanager.count - 1) do
	(
		tempLayer = layermanager.getlayer i
		if (tempLayer.ishidden == false) then
		(
			append FNLayerVisible (tempLayer.name)
		)
	)
	
	return FNLayerVisible
)



fn FindVisLayIdFN =
(
	local FNLayerVisibleId = #()
	
	for i = 0 to ( layermanager.count - 1) do
	(
		tempLayer = layermanager.getlayer i
		if (tempLayer.ishidden == false) then
		(
			append FNLayerVisibleId i
		)
	)
	
	return FNLayerVisibleId
)

LayerVisibleId = FindVisLayIdFN()

-- find layers hidden in asset by asset name
fn FindAssetHidByNameFN AllLayerAsset AssetName =
(
	for o in AllLayerAsset do 
	(
		if (o[1] == AssetName) then 
		(
			print ("layer cachés : " + (o[2] as string))
		)	
	)
)

-- find layers visibles in asset by asset name

fn FindAssetVisBayNameFN AllLayerAsset AssetName =
(
	for o in AllLayerAsset do 
	(
		if (o[1] == AssetName) then 
		(
			print ("layer cachés : " + (o[3] as string))
		)	
	)
)


rollout LayerManagerRLT "Layers Manager"
(
	Global LayerAsset = #()
	
	group "asset"
	(
		Listbox LayerAssetLBX "Layer Asset"
		button saveAssetBT "Save Asset" across: 2
		button LoadAssetBT "Load Asset"
	)
	
	group "Layers"
	(
		Multilistbox layerHiddenMLB "Layers Hidden" across: 2
		Multilistbox layerVisibleMLB "Layers Visibles"
		
		button GotoHideBT "<"
		button GotoSeeBT ">"
	)
	

	
	on LayerManagerRLT open do
	(		
		layerHiddenMLB.items = FindHiddenLayFN ()
		layerVisibleMLB.items = FindVisLayFN ()
		LayerAssetLBX.items = LayerAsset
	)
	
	on saveAssetBT pressed do
	(
		local OneAsset = #(((random 1 1000)as string), layerHiddenMLB.items , layerVisibleMLB.items)
		append AllLayerAsset OneAsset
		LayerAssetLBX.items = for o in AllLayerAsset collect o[1]
	)
	
	on LoadAssetBT pressed do
	(
		IdAsset = LayerAssetLBX.selection
		-- calques a cacher
		for o in AllLayerAsset[IdAsset][2] do
		(
			Templayer =  Lmgr.getLayerFromName o
			Templayer.ishidden = true
		)
		
		-- calques a decacher
		for o in AllLayerAsset[IdAsset][3] do
		(
			Templayer =  Lmgr.getLayerFromName o
			Templayer.ishidden = false
		)
		
		layerHiddenMLB.items =  FindHiddenLayFN ()
		layerVisibleMLB.items = FindVisLayFN ()
	)
	
	on layerHiddenMLB selectionEnd do
	(
		HidLayIdSel = layerHiddenMLB.selection as array
		print (HidLayIdSel as string)
		layerVisibleMLB.selection = #{}
		LayToMayBeSwap = #()
		
		LayToMayBeSwap = for o in HidLayIdSel collect (layerHiddenMLB.items)[o]
		print (LayToMayBeSwap as string)
	)
	
	on layerVisibleMLB selectionEnd do
	(
		VisLayIdSel = layerVisibleMLB.selection as array 
		print (VisLayIdSel as string)
		layerHiddenMLB.selection = #{}
		LayToMayBeSwap = #()
		LayIdToMayBeSwap = #()
		
		LayToMayBeSwap = for o in VisLayIdSel collect (layerVisibleMLB.items)[o]
		
		print (LayToMayBeSwap as string)
	)
	
	on GotoHideBT pressed do
	(
		print "youhou"
		for o in LayToMayBeSwap do
		(
			Templayer =  Lmgr.getLayerFromName o
			Templayer.ishidden = true
		)
		layerHiddenMLB.items = FindHiddenLayFN ()
		layerVisibleMLB.items = FindVisLayFN ()
	)
	
	on GotoSeeBT pressed do
	(
		print "youhou"
		for o in LayToMayBeSwap do
		(
			Templayer =  Lmgr.getLayerFromName o
			Templayer.ishidden = false
		)
		layerHiddenMLB.items = FindHiddenLayFN ()
		layerVisibleMLB.items = FindVisLayFN ()
	)
)

createdialog LayerManagerRLT width: 400

-- PROB: 
-- si je rename un calque le script plante (memoriser les calques par id et pas par nom)
-- si je supprime un calque le script plante
-- si j'ajoute un calque le script ne plante pas (?) 
