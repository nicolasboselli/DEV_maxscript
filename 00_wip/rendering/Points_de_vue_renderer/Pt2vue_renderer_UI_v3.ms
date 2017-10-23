/*
-- maj:
	/-  pendre en charge les scene state pour les diff�rents points de vue plutot que les cameras multiples
	
	--convertir un selection de camera en camera avec scene state
	-- convertir une serie de scene state en multiples cameras
	
	-- faire fonctionner le "batch from cam" sur une selection multiple de cameras
	/- faire fonctionner le rename � la selection de camera dans la liste

	/- creer vraycam avec target
		
	/- cr�er les �tats de camera et de soleil pour chaque vue (scene state)
	/- cr�er les lignes de batch render pour chaque camera � rendre
	-- cr�er des batch render depuis les scene state
		-- faire focntionner sur la selection
	
	-- proposer la position du soleil en fonction de la camera(droite, gauche)
	
-- bug:
	/- � la suppression ou � la creation de camera la selection est incorrecte, backuper la selection pour la reactiver au refresh
	-- faire un callback pour detecter la creation de camera
	-- faire un callback au changement de selection de camera dans la scene
*/
Global re = maxOps.GetCurRenderElementMgr ()

maxVers = getFileVersion "$max/3dsmax.exe"

-- vrayCreateVRayPhysicalCamera()

fn convertToVrCam s =
(
	if classof s == TargetCamera or classof s == FreeCamera or classof s == Physical then
	(
-- 		vrCam = VRayPhysicalCamera transform: s.transform name: s.name targeted: true specify_fov: true fov: s.fov vignetting: false shutter_speed: 150 f_number: 9 	whiteBalance_preset: 2 whiteBalance: (color 191.25 226.023 255)
		
		local vrayCam = vrayCreateVRayPhysicalCamera ()
		
		vrayCam.transform = s.transform
		vrayCam.name = s.name
		
		vrayCam.targeted = true
		
		vrayCam.specify_fov = true
		vrayCam.fov = s.fov
		
		vrayCam.vignetting = false

		vrayCam.shutter_speed = 150
		vrayCam.f_number = 9

		vrayCam.whiteBalance_preset = 2
		vrayCam.whiteBalance = color 191.25 226.023 255
		
		s.name = s.name + "_bak"
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
	local camToRender = #()
	
	local statesAr = #()
	local stateSel
	local stateSelAr = ()
	
	local outputPath
	local outputPathFolder
	
	local sceneCam = #()
			
	local camSel 
	local oneCamSelected = undefined
	
	local camSelAr
	
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
		
		-- collect cam to render
		camToRender = #()
		for cam in camCollected do
		(
			res = getUserProp cam "camToRender"
			if res != undefined then
			(
				if res then 
				(
-- 					format "cam to render: %\n" cam.name
					append camToRender cam
				)
				else
				(
-- 					format "cam to not render: %\n" cam.name
				)
			)
		)
		
-- 		format "cam to render: %\n" camToRender
		camCollected
	)
-- 	fn cam_filt obj = classof obj == freecamera

	fn collectSceneStates =
	(
		local num = sceneStateMgr.GetCount()   
		statesAr = for i = 1 to num collect sceneStateMgr.GetSceneState i
		sort statesAr
		format "statesAr: %\n" statesAr
	)


	-- def ui
	group "Camera Manager"
	(
		
		Multilistbox SceneCamsMLT "Scene Cameras:"  
-- 		button sortCamName "Classer par nom" across: 2
		button RebootCamBT "Refresh" across: 3 width: 120
		
		button selectCamBT "Select Cam" width: 120
		button CamViewBT "Camera View" width: 120
		button vrCamBT "convert to vr cam" enabled: true across: 3 width: 120
		

		button duplicateCamSelBT "Clone Cam"  width: 120
		button deleteReelCamBT "Del Cam" width: 120
		
-- 		button addCamSelect "Add to Render" width: 120 -- across: 2 
		
		edittext RenameCamEdit "Rename" 
		
-- 		pickbutton PickCam "Piquer une Camera"  filter: cam_filt across: 4

	)
		
	group "Scene States"
	(

-- 		button delOtherCamBT "Supprimer les autres"
		edittext sceneStateET "new scene state:" pos:[15,310] width: 420
		button newSceneStateBT "create" pos:[440, 310]
		Multilistbox CamsRenderMLT "scene states:"  
		
		
		
		button saveLigthStateBT "Save Scene State" width: 120 across: 3	
		button loadLigthStateBT "Load Scene State" width: 120
		button delCamSelect "Del Scene State Cam" width: 120 
	)
	
	group "Batch Render"
	(
		edittext savepath  "Path:" text: "" readonly: true
		button SelectPathFile "..." across: 3
		button createBatchRenderBT "Batch from Cam"
		button batchFromStateBT "Batch from State"
	)
	
-- 	functions UI dependant
	fn refreshUI =
	(
		-- refresh scene cameras
		SceneCamsMLT.items = for o in camArray collect o.name
		
		CamsRenderMLT.items = for o in statesAr collect o
		
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
		/*
		if camToRender.count > 0 then 
		(
			CamsRenderMLT.items = for o in camToRender collect o.name
		)
		else
		(
			CamsRenderMLT.items = #()
		)
		*/
	)

	fn getCamSelection =
	(
		oneCamSelected
		multiCamSel = (SceneCamsMLT.selection as array)
		
		format "selection: %, count: %\n" multiCamSel multiCamSel.count
		if multiCamSel.count ==1 then 
		(
			oneCamSelected = multiCamSel[1] 
			camSel = camArray[oneCamSelected]
			if isvalidnode camSel then format "camera selected: %\n" camSel.name
			camSelAr = #(camSel)
		)
		else if multiCamSel.count > 1 then
		(
-- 			print "youpi" 
			oneCamSelected == undefined
			camSel = undefined 
-- 			format "multi camera selection: %\n" multiCamSel
			camSelAr = for id in  multiCamSel collect camArray[id]
			
		)
		else
		(
			oneCamSelected == undefined
			camSel = undefined 
			camSelAr= #()
			format "none camera selection: %\n" multiCamSel
		)
		
		format "camSelAr: %\n" camSelAr
		
	)
	
-- Scene Camera actions
	on Pt2vue_renderer_UI open do
	(
		camArray = collectCamFN ()
		outputPath = getINISetting armadasScriptsIni "Pt2Vue" "outputPathFolder"
		
		collectSceneStates()
		
		refreshUI()
		
		if camArray.count > 0 then
		(
			SceneCamsMLT.selection = #{1}
			getCamSelection()
			refreshUI()
		)
		
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
		getCamSelection()		
		refreshUI()
	)
	
	on SceneCamsMLT doubleClicked oneCam do
	(
		format "onecam: %\n" oneCam
		
		getCamSelection()		
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
			getCamSelection()	
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
			getCamSelection()	
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
			getCamSelection()	
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
			getCamSelection()	
			refreshUI()
		)
		else format "SELECTION INCORRECTE"
	)
	
	on CamsRenderMLT selectionend do
	(
		local sel = CamsRenderMLT.selection as array
		
		if sel.count == 1 then
		(
			stateSel = CamsRenderMLT.items[sel[1]]
			stateSelAr = for i in CamsRenderMLT.selection collect CamsRenderMLT.items[i]
		)
		else if sel.count > 1 then
		(
			stateSel = undefined
			stateSelAr = for i in CamsRenderMLT.selection collect CamsRenderMLT.items[i]
		)
		else
		(
			stateSel = undefined
			stateSelAr = undefined
		)
		
		format "stateSel: %, stateSelAr:%\n" stateSel stateSelAr
	)
	
	on newSceneStateBT pressed do
	(
		sceneStateMgr.Capture sceneStateET.text #{1,2,4,5}
		
		collectSceneStates()
		refreshUI()
	)
	
	on saveLigthStateBT pressed do
	(
		-- retrouver la selection du scene state
		
		sceneStateMgr.Capture stateSel #{1,2,4,5}
		
		collectSceneStates()
		refreshUI()
	)
	
	on loadLigthStateBT pressed do
	(
		sceneStateMgr.Restore  stateSel #{1,2,4,5}
	)
	
	on SelectPathFile pressed do
	(
		outputPath = getSavePath caption: "Select \"point de vue\" folder" -- initialDir: pathToSearchET.text
		
-- 		outputPath = getBitmapSaveFileName filename: savepath.text
		
		if outputPath != undefined then
		(
			savepath.text = outputPath
-- 			suffixNameEdit.text = ".jpg"
-- 			fileNameType.text = getFilenameType outputPath
		)
		else
		(
			print "Fail"
		)
	)

	
	on createBatchRenderBT pressed do
	(
		for c in camselAr do
		(
			
		)
		
		-- prevoir les exception avec un find view
		local check = batchRenderMgr.FindView camSel.name
		if check == 0 then
		(
			local batch = batchRenderMgr.CreateView camSel
			batch.name = camSel.name
			local filename = outputPath + "\\" + camSel.name + ".jpg"
			format "path: %\n" filename
			
	-- 		test.sceneStateName = ""
			batch.outputFilename = filename
		)else(format "batch render deja existant: %\n" camSel.name)

	)
	
	on batchFromStateBT pressed do
	(
-- 		cam = $Camera001
-- 		outputPath = @"T:\BPD Marignan\SoBlagnac_0917\Perspectives\Perspectives\ptsdevue"
		num = sceneStateMgr.GetCount()   

		for i = 1 to num do
		(
			local oneName = sceneStateMgr.GetSceneState i
			
				-- prevoir les exception avec un find view
			local check = batchRenderMgr.FindView oneName
			if check == 0 then
			(
				local batch = batchRenderMgr.CreateView undefined
				batch.name = oneName
				batch.camera = camSel
-- 				format "outputPathFolder: %, outputPath: %\n" outputPathFolder outputPath
				local filename = outputPath + "\\" + oneName + ".jpg"
				format "path: %\n" filename
				
				batch.sceneStateName = oneName
				batch.outputFilename = filename
			)else(format "batch render deja existant: %\n" oneName)
		)
	)

)
createdialog Pt2vue_renderer_UI








	/*
	on addCamSelect pressed do 
	(
		
		if isvalidnode camsel then
		(
			setUserProp camsel "camToRender" true
			appendifunique camToRender camsel
			setUserProp camToRender[i] "camToRender" true
		)
		else format "SELECTION INCORRECTE"
		
		refreshUI()
	)
	*/
	
-- Render Camera actions
	/*
	on delCamSelect pressed do
	(
		cameToRemoveID = CamsRenderMLT.selection as array
		
		
		for i = cameToRemoveID.count to  1 by -1 do
		(
			
			format "cams to remove: %\n" camToRender[i].name
			deleteitem camToRender i
			setUserProp camToRender[i] "camToRender" false
-- 			format "cams to remove: %\n" camToRender[i].name
		)
		
-- 		format "cams to remove: %\n" cameToRemove
		
		for i=(SceneCamsMLT.selection as array).count to 1 by -1  do
		(			
			deleteItem camToRender (SceneCamsMLT.selection as array)[i]
		)
		
		refreshUI()
	)
	*/