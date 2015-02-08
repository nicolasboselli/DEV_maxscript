-- Utilise des variables et des fonctions de VraySelAlpha_ui.ms

-- Vars

global re =  maxOps.GetCurRenderElementMgr ()
global GeoSuperArray = #()

global ObjToAlpha = #()

global MultiMatScene = #()
global ObjWithMultiMat = #()
global MultiMatToAlpha = #()

global Black_Mat = Vraymtl name: "Black_Mat"

global MultLitMat = #()
-- Fonctions

-- collecte toutes les geometries de la scene
fn ColSceneGeoFN =
(
	local GeoScene = #()
	
	for o in ($* as array) do
	(
		if superclassof o == geometryclass then
		(
			append GeoScene o
		)
	)
	return GeoScene
)

-- collecte objets par materiau 
fn ColObjByMatFN ObjArray Mat = 
(
	local ObjByMat = #()
	
	for o in ObjArray do
	(
		if o.material == Mat then
		(
			append ObjByMat o
		)
	)
	
	return ObjByMat
)

-- collecte des multimaterial de la scene
fn ColMultiMatSceneFN ObjArray =
(
	local TempMultiMatScene = #()
	
	for o in ObjArray do
	(
		if classof (o.material) == multimaterial then
		(
			append TempMultiMatScene o.material
		)
	)
	
	return TempMultiMatScene
)

-- collecte des objets avec des multimaterial
fn ObjWithMultiInSceneFN ObjArray =
(
	local TempObjWithMultiMat = #()
	
	for o in ObjArray do
	(
		if classof (o.material) == multimaterial then
		(
			append TempObjWithMultiMat o
		)
	)
	
	return TempObjWithMultiMat
)

-- collecte et memorisation des multimaterial contenant le materiaux de l'editeur selectioné
fn FindMultiMatToAlphaFN MatArray refMat=
(
	local TempMultiMatToAlpha = #()
	
	for o in MatArray do
	(
		
		local submat
		
		submat = o.materialList
		
		for oneMat in submat do
		(
			if oneMat == refMat then
			(
				append TempMultiMatToAlpha o
			)
		)
	)
	TempMultiMatToAlpha = makeuniquearray TempMultiMatToAlpha
		
	return TempMultiMatToAlpha
)

FindMultiMatToAlphaFN 

-- creation des multimateriaux autoilluminés
fn CreateMultiLitMatFN MatArray MatRef =
(
	TempMultLitMat = #()

	for o in MatArray do
	(
		SubstiMat = Multimaterial numsubs: o.numsubs name: ("subStitute" + o.name)
		
		For i = 1 to SubstiMat.numsubs do
		(
			if o[i] == MatRef then
			(
				SubstiMat[i] = AutoIllumMat
			)
			else SubstiMat[i] = Black_Mat
		)
		append TempMultLitMat SubstiMat
	)
	return TempMultLitMat
)


rollout CurrentMatAlphaRLT "Material Alpha"
(
-- 	Vars
	Local MatToFind
	
-- 	UI
	button MakeAlphaSceneBT "Current Material" across:2 
	button MakeAllMeditAlpha "All Material"

	
-- 	Actions
	on MakeAlphaSceneBT pressed do
	(
-- PREPA OBJETS
		MatToFind = medit.GetCurMtl()

		GeoSuperArray = ColSceneGeoFN()

		-- Collecte OBJETS AVEC MATERIAU SELECTIONNE
		ObjToAlpha = ColObjByMatFN GeoSuperArray MatToFind

		-- Collecte des multiMaterial de la scene
		MultiMatScene = ColMultiMatSceneFN GeoSuperArray
		
		-- Collecte OBJETS AVEC MULTIMATERIAL de la scene 
		ObjWithMultiMat = ObjWithMultiInSceneFN GeoSuperArray

		-- collecte des multimaterial contenant le materiaux de l'editeur selectioné
		MultiMatToAlpha = FindMultiMatToAlphaFN MultiMatScene MatToFind

		-- preparation  des multimaterial avec les materiaux auto-illuminés
		MultLitMat = CreateMultiLitMatFN MultiMatToAlpha MatToFind

		-- application des materiaux autoilluminés
		for o in ObjToAlpha do o.material = AutoIllumMat
		
		for OneObj in ObjWithMultiMat do
		(
			for i = 1 to MultiMatToAlpha.count do
			(
				if OneObj.material == MultiMatToAlpha[i] then
				(
					OneObj.material = MultLitMat[i]
				)
			)
		)

-- RENDUS
		-- backup des parametres de rendu
		VrayStateBak = renderers.current
		backgroundColorBak = backgroundColor
		EnvironStateBak = useEnvironmentMap
		ExpoStateBak = sceneExposureControl.exposureControl
		RenderEltsStateBak = re.getElementsActive ()
		
		-- applicationd des params de rendus alpha
		renderers.current = VrayAlphaPreset
		useEnvironmentMap = false
		backgroundColor = (color 0 0 0)
		sceneExposureControl.exposureControl = undefined
		re.setElementsActive false
		
		SwapVrayCamExpFN false
		
		-- rendus
		max quick render
		
		-- recup des preset de rendu
		SwapVrayCamExpFN true
		
		renderers.current = VrayStateBak
		useEnvironmentMap = EnvironStateBak
		backgroundColor = backgroundColorBak
		sceneExposureControl.exposureControl = ExpoStateBak 
		re.setElementsActive RenderEltsStateBak
		
-- RECUP BAKUP
		-- recuperation du materiau
		for o in ObjToAlpha do o.material = MatToFind
			
		-- reapplication des multi materiaux 
		for OneObj in ObjWithMultiMat do
		(
			for i = 1 to MultiMatToAlpha.count do
			(
				if OneObj.material == MultLitMat[i] then
				(
					OneObj.material = MultiMatToAlpha[i]
				)
			)
		)
	)	
)

createdialog CurrentMatAlphaRLT width: 300

