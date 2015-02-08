-- Vars

Global re = maxOps.GetCurRenderElementMgr ()

-- Global AutoIllumMat = standard twosided: on Diffuse: (color 255 255 255) selfIllumAmount: 100
Global AutoIllumMat = vraylightmtl ()

-- meditMaterials[1] = AutoIllumMat

Global VrayBase = V_Ray_Adv_2_20_03 ()

VrayBase.imageSampler_type = 1
VrayBase.filter_on = false

VrayBase.gi_on = true

VrayBase.gi_primary_type = 0
VrayBase.gi_irradmap_showCalcPhase = true
VrayBase.gi_irradmap_showDirectLight = true
VrayBase.gi_irradmap_preset = 2
VrayBase.gi_irradmap_subdivs = 30

VrayBase.gi_secondary_type = 3
VrayBase.lightcache_subdivs = 400
VrayBase.lightcache_storeDirectLight = 0
VrayBase.lightcache_showCalcPhase = 1

VrayBase.colorMapping_type = 1
VrayBase.colorMapping_darkMult = 1.2
VrayBase.colorMapping_brightMult = 0.8
VrayBase.colorMapping_gamma = 2.2
VrayBase.colorMapping_linearWorkflow = true

Global VrayAlphaPreset = V_Ray_Adv_2_20_03 ()

VrayAlphaPreset.imageSampler_type = 1
VrayAlphaPreset.filter_on = false

VrayAlphaPreset.options_maps = false

VrayAlphaPreset.gi_on = false

VrayAlphaPreset.options_lights = false
VrayAlphaPreset.options_defaultLights = 0

VrayAlphaPreset.colorMapping_type = 0
VrayAlphaPreset.colorMapping_darkMult = 1
VrayAlphaPreset.colorMapping_brightMult = 1
VrayAlphaPreset.colorMapping_gamma = 1
VrayAlphaPreset.colorMapping_linearWorkflow = false

VrayAlphaPreset.options_reflectionRefraction = false
VrayAlphaPreset.options_overrideMtl_on = false

VrayAlphaPreset.system_raycaster_memLimit = 4000
VrayAlphaPreset.system_region_x = 16
VrayAlphaPreset.system_region_y = 16

Global vray_exp = (vray_exposure_control ())

-- fonction pour activer ou desactiver l'exposition des cameras vray
fn VrayCamExpStateFN TheState = 
(
	for o in ($* as array) do
	(
		if classof o == Vrayphysicalcamera then
		(
			o.exposure = TheState
		)
	)
)


-- rollout
rollout CurrentRender "Current Render"
(
	button VRScenebaseBT "Vray Sun Scene Creator" 
	
	group "preset"
	(
		button VRbasePresetBT "Vray Base Preset" across: 2
		button VRAlphaPresetBT "Vray Alpha Preset"
	)
	
	group "Render Alpha Selection"
	(
		button AlphaSelRenderBT "On Current Frame" across: 2
		button BatchAlphaSelRenderBT "On Selected BatchRender"
	)
	
	on CurrentRender open do
	(
		for o in ($* as array) do if (classof o == vraysun) then 
		(
			print "pas la peine d'en rajouter un" 
			VRScenebaseBT.enabled = false
		)
	)
	
	on  VRScenebaseBT pressed do
	(
		renderers.current = VrayBase
						
		dummy_target = dummy name: "vraysuntarget" 
		vraysun_test = VRaySun name:"VRaySun001" pos:[500,500,500] isSelected:on enabled:on turbidity: 2.0 ozone: 0 sky_model: 1 target: dummy_target

		environmentMap = vraysky ()
		useEnvironmentMap = true

		sceneExposureControl.exposureControl = vray_exp
	)
	
	on VRbasePresetBT pressed do
	(
		renderers.current = VrayBase
		useEnvironmentMap = true
		sceneExposureControl.exposureControl = vray_exp 
	)
	
	on VRAlphaPresetBT pressed do
	(
		renderers.current = VrayAlphaPreset
		useEnvironmentMap = false
		sceneExposureControl.exposureControl = undefined 
	)
	
	
	on AlphaSelRenderBT pressed do
	(
		-- backup material selection
		local SelToAlpha = $selection as array
		print SelToAlpha
		Material_Bak = for o in SelToAlpha collect o.material
		for o in SelToAlpha do o.material = AutoIllumMat
		
		-- backup des parametres de rendu
		VrayStateBak = renderers.current
		EnvironStateBak = useEnvironmentMap
		ExpoStateBak = sceneExposureControl.exposureControl
		RenderEltsStateBak = re.getElementsActive ()
		
		-- applicationd des params de rendus alpha
		renderers.current = VrayAlphaPreset
		useEnvironmentMap = false
		sceneExposureControl.exposureControl = undefined
		re.setElementsActive false
		VrayCamExpStateFN false
		
		-- rendus
		max quick render
		
		-- recup des materiaux originaux de la selection
		for i = 1 to SelToAlpha.count do SelToAlpha[i].material = Material_Bak[i]
		
		-- recup des preset de rendu
		renderers.current = VrayStateBak
		useEnvironmentMap = EnvironStateBak
		sceneExposureControl.exposureControl = ExpoStateBak 
		re.setElementsActive RenderEltsStateBak
		VrayCamExpStateFN true
	)
	
	on BatchAlphaSelRenderBT pressed do
	(
		if $selection.count > 0 then
		(
			-- vars
			local RenderList = batchRenderMgr

			local RenderListNameBak = #()
			local RenderListOutputBak = #()
			
			local SelToAlpha = $selection as array

			local RendNum = RenderList.numViews
			
			--	CREATION BAKUP
			
			-- backup des materiaux de la selection
			Material_Bak = for o in SelToAlpha collect o.material
			
			-- backup des parametres de rendu
			VrayStateBak = renderers.current
			EnvironStateBak = useEnvironmentMap
			ExpoStateBak = sceneExposureControl.exposureControl
			RenderEltsStateBak = re.getElementsActive ()
			
			-- bakup des batchrender
			for i = 1 to RendNum do
			(
			TempRender = RenderList.getview i
			append RenderListNameBak TempRender.name
			append RenderListOutputBak TempRender.outputFilename
				
			print TempRender.name
			print TempRender.outputFilename 
			)
			
			-- PARAMETRAGE du RENDU ALPHA
			-- 	application du materiel a la selection
			for o in SelToAlpha do o.material = AutoIllumMat
				
			-- 	application des prametres de rendu
			renderers.current = VrayAlphaPreset
			useEnvironmentMap = false
			sceneExposureControl.exposureControl = undefined
			re.setElementsActive false
			VrayCamExpStateFN false
			
			-- modif des noms de batchrender
			for i = 1 to RendNum do
			(
			TempRender = RenderList.getview i
			TempRender.name =  TempRender.name + "_alpha"
				
			TempRender.outputFilename = (substring TempRender.outputFilename 1 ((TempRender.outputFilename).count - 4 )) + "_alpha_" + ((random 1 10000) as string)+ "_.jpg"
				
			print TempRender.name
			print TempRender.outputFilename 
			)
			
-- 			Envoi des rendus
			renderSceneDialog.close()

			BakrendTimeType = rendTimeType

			rendTimeType = 2

			renderSceneDialog.commit ()

			batchRenderMgr.render ()

			rendTimeType = BakrendTimeType

			renderSceneDialog.open()
			
			-- RECUPERATION DES BAKUP
			
			-- bakup batchrender
			for i = 1 to RendNum do
			(
			TempRender = RenderList.getview i
			TempRender.name = RenderListNameBak[i]
			TempRender.outputFilename = RenderListOutputBak[i]
			
			-- recup des materiaux originaux de la selection
			for i = 1 to SelToAlpha.count do SelToAlpha[i].material = Material_Bak[i]
			
			-- recup des preset de rendu
			renderers.current = VrayStateBak
			useEnvironmentMap = EnvironStateBak
			sceneExposureControl.exposureControl = ExpoStateBak 
			re.setElementsActive RenderEltsStateBak
			VrayCamExpStateFN true
				
			print TempRender.name
			print TempRender.outputFilename 
			)
		)
		else
		(
			messagebox "select an object"
		)

	)
)

createdialog CurrentRender width: 400