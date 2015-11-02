-- sel = selection as array

fn mayaGrpFN sel =
(
	daddy = point name: (sel[1].name + "_null")
	
	objsToGrp = #()

	for s in sel do
	(
		isNotParented = false
		parentInSel = false
		
		if s.parent == undefined then isNotParented = true
		/*
		res = finditem sel s.parent 
		if res == 0 then print "parent is not in selection" else parentInSel = true
		*/
		if isNotParented then append objsToGrp s
	)

-- 	select objsToGrp
	for s in objsToGrp do
	(
		s.parent = daddy
	)
)


fn parentFN sel =
(
	undo on
	(
		daddy = sel[sel.count]
		
		for i = 1 to (sel.count - 1) do
		(
			sel[i].parent = daddy
		)
	)
)



fn selectAllChildren sel=
(
	for obj in sel do
		(
		if obj.children != undefined do
		(
			selectmore obj.children
		)
	)
)

fn unParent sel=
(
	for s in sel do s.parent = undefined
)

fn addUpperPoint obj =
(
	upPt = point name: (obj.name + "_zero") axis_tripod: false
	upPt.transform = obj.transform
	obj.parent = upPt
)


try(destroyDialog hierarchyRLT)catch()

rollout hierarchyRLT "hierarchy"
(
	button mayaGrpBT "maya group"
	button parentBT "parent"
	button unParentBT "unparent"
	button selectChidrenBT "select children"
	
	on mayaGrpBT pressed do mayaGrpFN (selection as array)
	on parentBT pressed do parentFN (selection as array)
	
	on selectChidrenBT pressed do selectAllChildren (selection as array)
	on unParentBT pressed do unParent (selection as array)
)

createdialog hierarchyRLT