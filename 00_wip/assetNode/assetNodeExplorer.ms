-- asset node explorer
try(destroydialog assetNodeExplorerRLT)catch()
rollout assetNodeExplorerRLT "Asset Nodes Explorer"
(
-- 	vars
	local menuRC
	local assetNodesAr
	local curAssetNode
	local btnSel
	local modf
	
-- 	functions
	fn initAssetNodeAr =
	(
		assetNodesAr = for o in objects where o.modifiers[#Content_Node] != undefined collect o
	)
	
-- 	UI
	listbox assetNodesLB "Asset Nodes:"
	
	group "Display:"
	(
		checkbutton RootCB "ROOT" highlightColor: orange width: 100 checked: true 
		checkbutton MainCtrlCB "MAIN_CTRL" highlightColor: (color 27 177 27) width: 100 checked: true
		checkbutton ScdCtrlCB "SECOND_CTRL" highlightColor: blue width: 100 checked: true
		checkbutton FacialCB "FACIAL" highlightColor: (color 177 88 27) width: 100 checked: true
		checkbutton RigCB "RIG" highlightColor: red width: 100 checked: true
		checkbutton MdlCB "MDL" highlightColor: (color 177 148 27) width: 100 checked: true
	)
	
	group "tools:"
	(
		button checkBT "check"
		button forceBT "force"
	)
	
-- 	UI functions
	fn refreshUI =
	(
		assetNodesLB.items = for a in assetNodesAr collect a.name
	)
	
	fn hideToggle btn =
	(
-- 		format "btn.text: %\n" btn.text
		curAssetNode = assetNodesAr[assetNodesLB.selection]
		
		res = finditem curAssetNode.modifiers[#Content_Node].catNameList btn.text
		
		objSet = curAssetNode.modifiers[#Content_Node].catContentList[res] 
		for o in objSet do o.ishidden = not btn.state
		redrawviews()
	)
	
	fn createRCMenu =
	(
		rcmenu menuRC
		(
			menuItem addIT "add"
			menuItem remIT "remove" 
			
			on addIT picked do	
			(	
				curAssetNode = assetNodesAr[assetNodesLB.selection]
				attr = curAssetNode.modifiers[#Content_Node]
				
				
				rlt =attr.allContentRLT
				format "btnSel.text: %\n" btnSel.text
				
				id = finditem attr.catNameList btnSel.text
				format "id: %\n" id
				format "cat: %\n" attr.catNameList[id]
				
				attr.addNode2 id
				attr.writeNodeTab ()
				attr.loadNodeTab ()
				hideToggle btnSel
				

			)
			
			on remIT picked do 
			(
				/*
				catId = CatLB.selection
				objId = ContentsLB.selection
				
				format "remove object: %\n" catContentList[catId][objId].name
				*/
			)
		)
	)
	
-- 	Actions
	on assetNodeExplorerRLT open do
	(
		createRCMenu()
		initAssetNodeAr()
		refreshUI()
	)
	
	on assetNodesLB selected obj do
	(
		select assetNodesAr[obj]
		modf = assetNodesAr[obj].modifiers[#Content_Node] 
		modf.loadNodeTab ()
	)
	
	on MainCtrlCB changed state do hideToggle MainCtrlCB
	on MainCtrlCB rightclick do 	
	(
		btnSel = MainCtrlCB
		popUpMenu menuRC rollout: assetNodeExplorerRLT
	)
	
	on ScdCtrlCB changed state do hideToggle ScdCtrlCB
	on ScdCtrlCB rightclick do
	(
		btnSel = ScdCtrlCB
		popUpMenu menuRC  rollout: assetNodeExplorerRLT
	)
	
	on RigCB changed state do hideToggle RigCB
	on RigCB rightclick do
	(
		btnSel = RigCB
		popUpMenu menuRC  rollout: assetNodeExplorerRLT
	)
	
	on MdlCB changed state do hideToggle MdlCB
	on MdlCB rightclick do
	(
		btnSel = MdlCB
		popUpMenu menuRC  rollout: assetNodeExplorerRLT
	)
	
	on FacialCB changed state do hideToggle FacialCB
	on FacialCB rightclick do
	(
		btnSel = FacialCB
		popUpMenu menuRC  rollout: assetNodeExplorerRLT
	)
	
	on checkBT pressed do
	(
		id  =  assetNodesLB.selection
		assetNodesAr[id].modifiers[#Content_Node].checkNodeTab()
	)
	
	on forceBT pressed do
	(
		id  =  assetNodesLB.selection
		assetNodesAr[id].modifiers[#Content_Node].writeNodeTab()
		assetNodesAr[id].modifiers[#Content_Node].loadNodeTab()
	)

)
createdialog assetNodeExplorerRLT


-- $.modifiers[#Content_Node].Content_Node.allContentList
