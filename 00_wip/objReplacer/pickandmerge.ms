-- pickandmerge

-- selection de l'objet
-- checkbutton picker
-- mouse down creation du point aligner sur l objet
-- mouse up : confirm
-- right mouse: abort



try(destroydialog PickNMergeRLT)catch()
rollout PickNMergeRLT "Pick And Merge"
(
-- 	vars
	local sourceObj
	local ctrl
	local mergeObjFolder
	local objList = #()
	local maxToMerge
	local thebox
	local mergedNodes
	
-- 	tool
	tool placeObjTool
	(
		on mousePoint clickno do
		(
			format "clickno1: %\n"  clickno
			mergeMAXFile maxToMerge mergedNodes: &mergedNodes
			
			sourceObj = point ()

			for o in mergedNodes do o.parent = sourceObj
			
			local myRay = mapScreenToWorldRay viewPoint
			local arr = intersectRayScene myRay
			
			local viewMatrix =  Inverse(viewport.getTM())
			local viewPos = viewMatrix.pos
			local nearestDist = 1000000
			local goodRes = undefined
			
			if arr.count>0 do	
			(				
				for obj in arr do
				(
					for mn in mergedNodes do
					(
						if obj[1] != sourceObj and obj[1] != mn and obj[1].ishidden == false do
						(
							tmpDist = distance viewPos obj[2].pos
							
							if tmpDist < nearestDist do
							(
								nearestDist = tmpDist
								goodRes = obj
							)
						)
					)
				)
			)			
			
			if goodRes != undefined do
			(
				sourceObj.controller.pos.controller.value =  goodRes[2].pos
				sourceObj.dir =  goodRes[2].dir
			)
		)

		on mouseMove clickno do
		(
			format "clickno2: %\n"  clickno
			if lButton == true do
			(
				local myRay = mapScreenToWorldRay viewPoint

				local arr = intersectRayScene myRay
				
				local viewMatrix =  Inverse(viewport.getTM())
				local viewPos = viewMatrix.pos
				local nearestDist = 1000000
				local goodRes = undefined
				
				if arr.count>0 do	
				(				
					for obj in arr do
					(
						if obj[1] != sourceObj  and obj[1] != thebox and obj[1].ishidden == false do
						(
							tmpDist = distance viewPos obj[2].pos
							
							if tmpDist < nearestDist do
							(
								nearestDist = tmpDist
								goodRes = obj
							)
						)
					)
				)			
				
				if goodRes != undefined do
				(
					undo on
					(
						sourceObj.controller.pos.controller.value =  goodRes[2].pos
						sourceObj.dir =  goodRes[2].dir
					)
				)
			)
		)
		
		on mouseAbort clickno do
		(
			format "clickno3: %\n"  clickno
			if isvalidnode sourceObj then delete sourceObj
		)
	)
	
-- 	UI
	edittext mergeListPathET text: "" readonly: true 
	button selPathBT "..."
	listbox mergeListLB "merge list:"
	checkbutton mergeCB "merge"
	
	
-- 	functions
	fn refreshui =
	(
		if mergeObjFolder != undefined then mergeListPathET.text = mergeObjFolder else mergeListPathET.text = "NONE"
		mergeListLB.items = for  o in objList collect (getFilenameFile o)
	)
	
-- 	actions
	on PickNMergeRLT open do
	(
		mergeObjFolder = @"N:\Ressources_Nico\merge"
		
		if mergeObjFolder != undefined then
		(	
			(
				if doesfileexist mergeObjFolder then
				(
					objList = getfiles (mergeObjFolder + "/*.max")
				)
			)	
		)
		
		refreshUI ()
		
	)
	
	on selPathBT pressed do
	(
		mergeObjFolder = getSavePath caption: "Select object to merge folder"
		
		if mergeObjFolder != undefined then
		(	
			(
				if doesfileexist mergeObjFolder then
				(
					objList = getfiles (mergeObjFolder + "/*.max")
				)
			)	
		)
		
		refreshUI ()
	)
	
	on mergeListLB select id do
	(
		maxToMerge = objList[id]
	)
	
	on mergeCB changed state do
	(	
		local id = mergeListLB.selection
		maxToMerge = objList[id]
		format "maxToMerge: %\n" maxToMerge
		
		if state == true do
		(
			continueTool = true
			while continueTool == true do
			(
				continueTool = starttool placeObjTool
			)
			mergeCB.state = false
		)
	)
	
)
createdialog PickNMergeRLT