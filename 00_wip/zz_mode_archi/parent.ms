-- sel = selection as array

fn mayaGrpFN sel =
(
	daddy = point name: (sel[1].name + "_null")
	for s in sel do
	(
		s.parent = daddy
	)
)


fn parentFN sel =
(
	daddy = sel[sel.count]
	
	for i = 1 to (sel.count - 1) do
	(
		sel[i].parent = daddy
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


rollout hierarchyRLT "hierarchy"
(
	button mayaGrpBT "maya group"
	button parentBT "parent"
	button unParentBT "unparent"
	button selectChidrenBT "select children"
	
	on mayaGrpBT pressed do mayaGrpFN selection
	on parentBT pressed do parentFN selection
	
	on selectChidrenBT pressed do selectAllChildren selection
)

createdialog hierarchyRLT