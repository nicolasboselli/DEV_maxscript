-- amelioration: 
--x - r�cup�rer le nom de la version de vray pr�sente
--x rectifier les valeurs d IRmap en low, mettre 4000 en memoire
-- proposer d'activer le gamma de max


fn findVray  =
(
	for r in rendererClass.classes do
	(
		if matchPattern  (r as string)  pattern: "V_Ray_Adv*" do return r
		break
	)
)


-- rollout
rollout VrayRenderRLT "Vray Options"
(

-- 	vars
	local vrayClass = findVray()
	
	fn  colorMapTest =
	(
		return true
	)

	local vrayBase = vrayClass \
	imageSampler_type: 1 \
	filter_on: false \
	gi_on: true \
	gi_primary_type: 0 gi_irradmap_showCalcPhase: true  gi_irradmap_showDirectLight: true  gi_irradmap_minRate: -3  gi_irradmap_maxRate: -2 gi_irradmap_subdivs: 30  gi_irradmap_preset: 2\
	gi_secondary_type: 3  lightcache_subdivs: 400 lightcache_storeDirectLight: 0 lightcache_showCalcPhase: 1 \
	colorMapping_type: 0 colorMapping_darkMult: 1.0 colorMapping_brightMult: 1.0 colorMapping_gamma: 2.2 colorMapping_linearWorkflow: false --colorMapping_adaptationOnly: (colorMapTest())

	local vrayExp = vray_exposure_control shutter: 150 f_number: 9 iso: 100 wb_preset: 1 white_balance: [1,1,1]

-- 	functions
	fn createInfiniteGround =
	(
		local vrGround
		test = getnodebyname "vr_ground"
		
		if test == undefined then
		(
			solMat = vraymtl name: "sol_mat"
			vrGround = vrayplane name: "vr_ground" pos: [0,0,-50]
			vrGround.material = solMat
		)
		else 
		(
			vrGround = test
		)
		return vrGround
	)



	fn createVraySun =
	(
		local vraySunVar = undefined
		local val = 2000
		local vraySunExist = false
		
		for o in lights do
		(
			if classof o == vraysun then
			(
				vraySunExist = true
				vraySunVar = o
				print "vray sun still exists"
				break
			)
		)
		
		if vraySunExist == false do
		(
		-- vray sun
-- 			dummy_target = dummy name: "vraysuntarget" 
			dummy_target = Targetobject wirecolor: yellow
			vraySunVar = VRaySun name:"VRaySun001" pos:[val,val,val] isSelected:on size_multiplier: 4 enabled:on turbidity: 2.5 ozone: 0.35 sky_model: 0 target: dummy_target
			-- enviraonnement
		)
		
		if (classof environmentMap) != vraysky do
		(
			environmentMap = vraysky ()
		)
		
		useEnvironmentMap = true
		
		return vraySunVar
	)
	
-- 	UI
	button VRScenebaseBT "Vray scene Basic" 
	
	group "creations:"
	(
		button vrayBaseSetBT "Vray base settings"
		button vraySunBT "vray sun and sky"
		button vrayExposureBT "vray exposure"
		button createVrayGroundBT "vray ground"
	)

-- 	Actions
	on  VRScenebaseBT pressed do
	(
		-- settings
		renderers.current = copy VrayBase
						
		-- vray sun
		createVraySun()
		
		-- exposure
		sceneExposureControl.exposureControl =  vrayExp
	)
	
	on vrayBaseSetBT pressed do
	(
		renderers.current = copy VrayBase
	)
	
	on vraySunBT pressed do
	(
		createVraySun()
	)
	
	on vrayExposureBT pressed do
	(
		sceneExposureControl.exposureControl =  vrayExp
	)
	
	on createVrayGroundBT pressed do
	(
		createInfiniteGround()
	)
)

createdialog VrayRenderRLT 







