-- structure to collect and keep grid object
struct gridST
(
	obj,
	name = obj.name
)

-- fonction to collect grids in the scene
--return array of the grid with home grid first
fn collectGridFN =
(
	local gridAr = #(gridST undefined "home")
	
	for obj in $* do
	(
		if (classof obj) == grid do
		(
			print obj
			gridObj = gridST obj
			append gridAr gridObj
		)
	)
	return gridAr
)

rollout gridRLT "Grids Manager"
(
	--vars
	local gridList = #()
	-- ui
	listbox gridsLB "Grids List :"
	button refrListBT "refresh list"
	button gridViewBT "grid view"
	
-- 	fn
	fn refreshUIFN =
	(
		gridList = collectGridFN()
		gridsLB.items = for oneGrid in gridList collect oneGrid.name
	)
	
	-- actions
	on gridViewBT pressed do
	(
		num = gridsLB.selection		
		
		activeGrid = gridList[num].obj

		viewport.setType #view_grid
		viewport.setType #view_iso_user
	)
	
	on refrListBT pressed do refreshUIFN()
	on gridRLT open  do refreshUIFN()
	
)

createdialog gridRLT


