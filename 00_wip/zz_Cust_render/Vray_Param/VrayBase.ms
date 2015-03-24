-- amelioration: 
-- - récupérer le nom de la version de vray présente
-- rectifier les valeurs d IRmap en low, mettre 4000 en memoire
-- vérifier que ça n'active pas le gamma de max
-- test renderer installation

-- Vars
-- Global AutoIllumMat = standard twosided: on Diffuse: (color 255 255 255) selfIllumAmount: 100
Global AutoIllumMat = vraylightmtl ()

-- meditMaterials[1] = AutoIllumMat

-- Global VrayBase = V_Ray_Adv_2_20_03 ()

-- VrayBase.imageSampler_type = 1
-- VrayBase.filter_on = false

VrayBase = V_Ray_Adv_2_20_03 \
imageSampler_type: 1 \
filter_on: false \
gi_on: true \
-- gi irradiance setup setup
gi_primary_type: 0 gi_irradmap_showCalcPhase: true  gi_irradmap_showDirectLight: true  gi_irradmap_preset: 2 gi_irradmap_subdivs: 30 \

-- gi light cache setup
gi_secondary_type: 3  lightcache_subdivs: 400 lightcache_storeDirectLight: 0 lightcache_showCalcPhase: 1

VrayBase.colorMapping_type = 1
VrayBase.colorMapping_darkMult = 1.2
VrayBase.colorMapping_brightMult = 0.8
VrayBase.colorMapping_gamma = 2.2
VrayBase.colorMapping_linearWorkflow = false

Global VrayAlphaPreset = V_Ray_Adv_2_20_03 ()

VrayAlphaPreset.imageSampler_type = 1
VrayAlphaPreset.filter_on = false

VrayAlphaPreset.gi_on = false

VrayAlphaPreset.options_lights = false
VrayAlphaPreset.options_defaultLights = 0

VrayAlphaPreset.colorMapping_type = 0
VrayAlphaPreset.colorMapping_darkMult = 1
VrayAlphaPreset.colorMapping_brightMult = 1
VrayAlphaPreset.colorMapping_gamma = 2.2
VrayAlphaPreset.colorMapping_linearWorkflow = false

Global vray_exp = (vray_exposure_control ())



-- rollout
rollout VrayRenderRLT "Vray Options"
(
-- 	UI
	button VRScenebaseBT "Vray Scene Base" 
	
	group "Presets:"
	(
		button VRbasePresetBT "Vray Base Preset" 
		button VRAlphaPresetBT "Vray Alpha Preset"
	)
	
	button AlphaSelRenderBT "Render Alpha of Selection"
	
-- 	Actions
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
		-- prepa de la selection
		SelToAlpha = $selection as array
		print SelToAlpha
		Material_Bak = for o in SelToAlpha collect o.material
		for o in SelToAlpha do o.material = AutoIllumMat
		
		-- prepa du rendu
		VrayStateBak = renderers.current
		EnvironStateBak = useEnvironmentMap
		ExpoStateBak = sceneExposureControl.exposureControl
		
		renderers.current = VrayAlphaPreset
		useEnvironmentMap = false
		sceneExposureControl.exposureControl = undefined
		
		-- rendus
		render()
		
		-- recup de la selection
		for i = 1 to SelToAlpha.count do SelToAlpha[i].material = Material_Bak[i]
		
		-- recup des preset de rendu
		renderers.current = VrayStateBak
		useEnvironmentMap = EnvironStateBak
		sceneExposureControl.exposureControl = ExpoStateBak 
		
	)
)

createdialog VrayRenderRLT 