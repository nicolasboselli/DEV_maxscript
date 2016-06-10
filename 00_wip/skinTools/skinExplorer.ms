-- todo: faire un callback de la selection de bones dans la scene, et du changement de skin modifier


filein "skinAddWeight.ms"

try(destroydialog skinExpRLT)catch()
rollout skinExpRLT "Skin Explorer"
(

-- 	vars
	local skinBonesAr
	local skinBonesToDisp
	local skinMaxBones
	local m
	local skinNEC
	local skinNECSub
	
-- Structures
	struct boneStruct 
	(
		id,  
		name = (skinOps.GetBoneName m id 0),
		node = getnodebyname name,
		isLocked = false,
		isHidden = false,
		fn displayName = 
		(
			lockTag = if isLocked == false then "" else "_(L)"
			hideTag =  if isHidden == false then "" else "_(H)"
			name + lockTag + hideTag
		),
		fn lockToggle = isLocked = not isLocked,
		fn hideToggle = isHidden = not isHidden
	)
	


-- 	UI
	edittext skinModET "Skin Modifier:" readonly: true
	
	group "Actions:"
	(
		button addBt "Add Bones" across: 4
		button removeBT "Remove"
		button lockBT "Lock/Unlock"
		button hideBT "Hide/Unhide"
	)
	group "display:"
	(
		checkbox hiddenCB "hidden" checked: true across: 2
		checkbox lockedCB "locked" checked: true
		edittext searchET "Search:" 
	)
	group "vertex tools:"
	(
		button additionToolBT "weight addition"
	)
	
	listbox bonesListLB "Bones:" height: 20
	
-- function UI dependant
	
	fn refreshList =
	(	
		skinBonesToDisp = for o in skinBonesAr collect o
		bonesListLB.items = for o in skinBonesToDisp collect o.displayName()
	)
	
	fn refreshUI  = 
	(
		m
		sel = selection  as array
		if sel.count > 0 then m = modPanel.getCurrentObject()
		
		if classof m == skin then
		(
			format "m: %\n" m
			skinMaxBones = skinOps.GetNumberBones m
			skinBonesAr = for i = 1 to skinMaxBones collect (boneStruct id: i)
			
			refreshList()
			skinModET.text = sel[1].name
		)
		else
		(
			skinMaxBones = 0
			skinBonesAr = #()
			
			skinBonesToDisp = for o in skinBonesAr collect o
			bonesListLB.items = for o in skinBonesToDisp collect o.displayName()
			
			skinModET.text = "NONE"
		)
		
	)
	
	fn refreshUI_NEC ev nd = 
	(
		refreshUI()
		print "done"
	)
	
	fn boneSelected_NEC ev nd =
	(
		
	)
	
	-- 	Actions
	on skinExpRLT open do
	(
		refreshUI()
		
		skinNEC = NodeEventCallback  selectionChanged: refreshUI_NEC
		skinNECSub = NodeEventCallback subobjectSelectionChanged: refreshUI_NEC
	)
	
	on skinExpRLT close do
	(
		skinNEC = undefined
		skinNECSub = undefined
		gc light:true
	)
	
	on bonesListLB selected id do
	(
		skinOps.SelectBone m skinBonesToDisp[id].id
	)
	
	on lockBT pressed do
	(
		skinBonesToDisp[bonesListLB.selection].lockToggle()
		refreshList()
	)
	
	on hideBT pressed do
	(
		skinBonesToDisp[bonesListLB.selection].hideToggle()
		refreshList()
	)
	
	on additionToolBT pressed do
	(
		createdialog addWtRLT
		addWtRLT.parentRLT = skinExpRLT
	)
	
)
createdialog skinExpRLT width: 400 