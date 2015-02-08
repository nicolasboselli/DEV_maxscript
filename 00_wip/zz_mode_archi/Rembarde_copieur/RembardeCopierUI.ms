Rollout RembardeCopierUi "Rembarde Copier UI" width: 400

(
-- 	vars
	local toto = #()
	local SuperModRef
	local NumRef
	local TempColor
	local workingCopy
	
-- 	functions
	fn CleanCopyFN s =
	(
		-- clean de la selection
		WorkingCopy = copy s
		WorkingCopy.name = uniquename "Rembarde_"
		WCModCount = WorkingCopy.modifiers.count
		for i = 1 to WCModCount do
		(
			deletemodifier WorkingCopy 1
		)
	)
	
	fn ConvertToReelSplineFN v2 =
	(
		addmodifier v2 (Edit_Spline ())
		converttosplineshape v2
		updateshape v2
	)
	
	fn ApplyModelFN WorkingCopyVars =
	(
		-- application du modele a la selection
		for i = 1 to (NumRef - 1) do
		(
			CopyTemp = reference WorkingCopyVars
			CopyTemp.name = uniquename (WorkingCopyVars.name + "_inst_")
			copytemp.wirecolor = TempColor
			CopyTemp.material = toto[i].material
			ModifiersCount = toto[i].modifiers.count
			for j = ModifiersCount to 1 by -1 do
			(
				addmodifier CopyTemp toto[i].modifiers[j]
			)
		)
	)
	
-- 	UI

	group "start"
	(
		button StartRembardeBT "start" across: 2
		button addLiceBT "add Lice"
	)
	
	group "copy"
	(
		pickbutton SelRefPB "Pick reference"
		button SelRefBT "Add reference" 
		edittext RefNameET readonly: true text: "reference"
	)
	group "paste"
	(
		button ApplyModelBT "appliquer la reference"
	)

	
-- 	Actions
	
	on StartRembardeBT pressed do
	(
		CleanCopyFN $
		ConvertToReelSplineFN workingCopy
		StartRembarde = workingCopy
		StartRembarde.name = uniquename "rembarde_"
		Pas = 0
		for i = 1 to 3 do
		(
			CopyRembarde = reference StartRembarde
			CopyRembarde.name = uniquename (StartRembarde.name + "_inst_")
			
			addmodifier CopyRembarde (sweep ())
			
			CopyRembarde.modifiers[#Sweep].CurrentBuiltInShape = 4
			CopyRembarde.modifiers[#Sweep].PivotAlignment = 5
			CopyRembarde.modifiers[#Sweep].yOffset = 50 + pas
			CopyRembarde.modifiers[#Sweep].XOffset = -5
		-- 				CopyRembarde.modifiers[#Sweep][#Cylinder_Section].radius = 3	
			
			pas += 25
		)
	)
	
	on addLiceBT pressed do
	(
		print "toto"
		newLice = reference $
		addmodifier newLice (sweep ())
	)

	
	
	on SelRefPB picked ModRef do
	(
		print ModRef
		RefNameET.text = ModRef.name
		SuperModRef = ModRef
	)
	
	on SelRefBT pressed do
	(
		if $selection.count == 1 then
		(
			RefNameET.text = $.name
			SuperModRef = $
		)
		else
		(
			messagebox "selectionner une seule reference"
		)
	)
		
	on ApplyModelBT pressed do
	(
		if SuperModRef != undefined then
		(
			if $selection.count == 1 then
			(
				NumRef = InstanceMgr.GetInstances SuperModRef &toto
				print NumRef
				print toto
				
				TempColor = color (random 1 255) (random 1 255) (random 1 255)
			
				CleanCopyFN $
				ConvertToReelSplineFN workingCopy
				ApplyModelFN workingCopy
			)
			else 
			(
				messagebox "selectionner un objet pour appliquer le modele"
			)
		)
		else
		(
		messagebox "selectionner un modele"
		)
	)
)

createdialog RembardeCopierUi

classof $ == SplineShape
classof $
