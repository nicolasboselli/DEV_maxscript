-- maj:

	-- faire fonctionner les actions sur les cameras sur une selection multiple
	-- sauver les informations du renderu de points de vue dans la scene
		
	-- créer les états de camera du soleil pour chaque vue(scene state)
	-- créer les lignes de batch render pour chaque camera à rendre
	
	-- proposer la position du soleil en fonction de la camera(droite, gauche)

Global re = maxOps.GetCurRenderElementMgr ()

maxVers = getFileVersion "$max/3dsmax.exe"

-- vrayCreateVRayPhysicalCamera()

fn convertToVrCam s =
(
	if classof s == TargetCamera or classof s == FreeCamera or classof s == Physical then
	(
		vrCam = VRayPhysicalCamera transform: s.transform name: s.name targeted: false specify_fov: true fov: s.fov vignetting: false shutter_speed: 150 f_number: 9 	whiteBalance_preset: 2 whiteBalance: (color 191.25 226.023 255)
		s.name = s.name + "_bak"
		vrCam.specify_fov = false
	)
	else(format "camera inconvertible: %\n" s)
)

try(destroyDialog Pt2vue_renderer_UI)catch()
rollout Pt2vue_renderer_UI "Rendeur de points de vues" width: 500
(
	local maxIni = getMAXIniFile()
	local armadasScriptsIni = (getFilenamePath maxIni) + "armadasScriptsIni.ini"
	
	-- 	vars
	local renderSize
	
	local camArray = #()
	global camToRender -- = #()
	
	local outputPath
	local outputPathFolder
	
	local sceneCam = #()
			
	local camSel 
	local oneCamSelected = undefined
	
	local Pt2vueNode
	
	-- vars maquette materials
	/*
	local vr=renderers.current

	local MatMaqDirt = VRayDirt radius: 100 occluded_color: (color 104 129 146) unoccluded_color: (color 230 230 230 )
	local OverMatMaquette = VRayMtl name: "over_maquette" diffuse:  (color 230 230 230 ) texmap_diffuse: MatMaqDirt
	
	local AtmosVRtoon =  VrayToon widthtype: 1 color: (color 72 96 108)	opacity: 0.8 lineworld: 2

	local OverMatVitre = VRayMtl name: "over_vitre" diffuse:  (color 92 175 196 ) 
	*/
-- 	vars bakup

		
	-- functions
	fn sortbyname v1 v2 =
	(
	-- 	vars
		local d
		
		if ( v1.name < v2.name) then
			d=-1
		else
			d=1
		
	--compare les numeros entre eux et les classe	
		case of
		(
			(d < 0.): -1
			(d > 0.): 1
			default: 0
		)
	)
	
	fn collectCamFN =
	(
		local camCollected = for c in cameras where classof c != Targetobject collect c
		qsort camCollected sortbyname
		camCollected
	)
-- 	fn cam_filt obj = classof obj == freecamera



	-- def ui
	group "Camera Manager"
	(
		
		Multilistbox SceneCamsMLT "Scene Cameras:"  
-- 		button sortCamName "Classer par nom" across: 2
		button RebootCamBT "Refresh"
		
		button selectCamBT "Select Cam" across: 3
		button CamViewBT "Camera View"
		button vrCamBT "convert to vr cam" enabled: true
		

		button duplicateCamSelBT "Clone Cam" across: 3
		button deleteReelCamBT "Del Cam"
		
		button addCamSelect "Add to Render" across: 2
		
		edittext RenameCamEdit "Rename" 
		
-- 		pickbutton PickCam "Piquer une Camera"  filter: cam_filt across: 4

	)
		
	group "Point de vue renderer"
	(

-- 		button delOtherCamBT "Supprimer les autres"
		
		Multilistbox CamsRenderMLT "Render Cameras:"  
		
		
		button delCamSelect "Remove Cam" across: 3
		button saveLigthStateBT "Save Light State"
		button loadLigthStateBT "Load Light State"
		
		
		edittext savepath  "Path:" text: "" readonly: true
		
-- 		edittext suffixNameEdit "File Name :"  text: "" readonly: false across: 2
-- 		edittext fileNameType "Type: " text: "" readonly: true
		
		button SelectPathFile "..." across: 2
		button createBatchRenderBT "Generate Batch Render"
-- 		button rendCamSelBT "Render Selection"		
	)
	
-- 	functions UI dependant
	fn refreshUI =
	(
		-- refresh scene cameras
		SceneCamsMLT.items = for o in camArray collect o.name
		
		if isvalidnode camSel then 
		(
			RenameCamEdit.text = camSel.name 
			if classof camSel != VRayPhysicalCamera then vrCamBT.enabled = true else vrCamBT.enabled = false
		)
		else 
		(
			RenameCamEdit.text = "[SELECTION INCORRECTE]"
		)
		
		-- refresh render cameras
		if camToRender.count > 0 then 
		(
			CamsRenderMLT.items = for o in camToRender collect o.name
		)
		else
		(
			CamsRenderMLT.items = #()
		)
	)

	
-- Scene Camera actions
	on Pt2vue_renderer_UI open do
	(
		camArray = collectCamFN ()
		refreshUI()
		
		savepath.text = getINISetting armadasScriptsIni "Pt2Vue" "outputPathFolder"
		format  "outputPathFolder: %\n" savepath.text		
	)
	
	on Pt2vue_renderer_UI close do
	(
		if savepath.text != undefined do
		(
			setINISetting armadasScriptsIni "Pt2Vue" "outputPathFolder" 	savepath.text
		)
	)
	
	on SceneCamsMLT selectionEnd do
	(
		local oneCamSelected
		multiCamSel = (SceneCamsMLT.selection as array)
		
		if multiCamSel.count ==1 then 
		(
			oneCamSelected = multiCamSel[1] 
			camSel = camArray[oneCamSelected]
			format "camera selected: %\n" camSel.name
		)
		else if multiCamSel.count > 1 then
		(
			for id in multiCamSel do
			(
				append 
			)
		)
		else
		(
			oneCamSelected == undefined
			camSel = undefined 
			format "multi camera selection: %\n" multiCamSel
		)
		
		refreshUI()
	)
	
	on SceneCamsMLT doubleClicked oneCam do
	(
		viewport.setCamera camSel
		select  camSel
	)		

	on RebootCamBT pressed do
	(
		camArray = collectCamFN ()
		refreshUI()
	)
	
		
	on selectCamBT pressed do
	(
		if camsel != undefined then select camsel else format "SELECTION INCORRECTE"
	)
	
	on CamViewBT pressed do
	(
		if isvalidnode camSel then
		(
			viewport.setCamera camsel 
		)
		else format "SELECTION INCORRECTE"
	)
	
	on vrCamBT pressed do
	(
		if isvalidnode camSel then
		(
			convertToVrCam camSel
			
			camArray = collectCamFN ()
			refreshUI()
		)
		else format "SELECTION INCORRECTE"
	)
		
	on duplicateCamSelBT pressed do
	(
		if isvalidnode camSel then
		(
			copy camsel
			
			camArray = collectCamFN ()
			refreshUI()
		)
		else format "SELECTION INCORRECTE"
	)
		
	on deleteReelCamBT pressed do
	(
		if isvalidnode camSel then
		(
			delete camsel
			
			camArray = collectCamFN ()
			refreshUI()
		)
		else format "SELECTION INCORRECTE"
	)
	
	on RenameCamEdit entered NewNameString do 
	(
		if isvalidnode camSel then
		(
			camsel.name = NewNameString
			
			camArray = collectCamFN ()
			refreshUI()
		)
		else format "SELECTION INCORRECTE"
	)
	

	on addCamSelect pressed do 
	(
		if isvalidnode camsel then
		(
			appendifunique camToRender camsel
		)
		else format "SELECTION INCORRECTE"
		
		refreshUI()
	)
	
-- Render Camera actions
	on delCamSelect pressed do
	(
		cameToRemoveID = CamsRenderMLT.selection as array
		
		
		for i = cameToRemoveID.count to  1 by -1 do
		(
			format "cams to remove: %\n" camToRender[i].name
			deleteitem camToRender i
-- 			format "cams to remove: %\n" camToRender[i].name
		)
		
-- 		format "cams to remove: %\n" cameToRemove
		/*
		for i=(SceneCamsMLT.selection as array).count to 1 by -1  do
		(			
			deleteItem camToRender (SceneCamsMLT.selection as array)[i]
		)
		*/
		refreshUI()
	)
	
-- 	chemin enregistrement
	
	on SelectPathFile pressed do
	(
		outputPath = getBitmapSaveFileName filename: savepath.text
		
		if outputPath != undefined then
		(
			savepath.text = getFilenamePath outputPath
			suffixNameEdit.text = getFilenameFile outputPath
			fileNameType.text = getFilenameType outputPath
		)
		else
		(
			print "Fail"
		)
	)
	

	on MaqRenderCB changed thestate do
	(
		vr.options_overrideMtl_on = thestate
		setActive AtmosVRtoon thestate
	)
	
-- 	render
	on rendCamSelBT pressed do
	(
		if savepath.text =="" then
		(			
			messagebox "définir un chemin d'enregistrement"
		)
		else if suffixNameEdit.text == "" then 
		(
			messagebox "définir un chemin d'enregistrement"
		)
		else if fileNameType.text == "" then
		(
			messagebox "définir un chemin d'enregistrement"
		)
		else
		(
			/*
			renderSize = case RenderSizeRB.state of
			(
				1: 750
				2: 1500
			)
			*/
			
			camAr = (SceneCamsMLT.selection) as array
			
			for i = 1 to camAr.count do
			(
				renderSceneDialog.close ()	
				
				outputPathNameDef = (savepath.text + suffixNameEdit.text + "_" + CamArray[camAr[i]].name + fileNameType.text)
			
				bakOutput = rendOutputFilename
				bakWidth = renderWidth
				bakHeight = renderHeight
				 
-- 				rendTimeType = 1
				rendSaveFile = true
-- 				rendusenet = NetRenderCB.state
				rendOutputFilename =  outputPathNameDef
				
-- 				renderWidth = 1500
-- 				renderHeight = 1000
				
				
				re.setElementsActive false
				
-- 				CleanOutEltsFN ()
				viewport.setCamera CamArray[camAr[i]]

				renderSceneDialog.commit()
				max quick render

				rendOutputFilename = bakOutput
				renderWidth = bakWidth
				renderHeight = bakHeight
				

			)
		)
	)
	

)

createdialog Pt2vue_renderer_UI



--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
-- ameliorations:

-- parametrer la taille de l'image

	-- conserver plusieurs asset de camera


	-- ajouter directement la date et le nom du rendu au rendu (script photoshop)




