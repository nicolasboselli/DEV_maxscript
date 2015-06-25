filein "windows_placer_fn.ms"
filein "objReplacerDef.ms"

fn centerizeGroupFN =
(
	print "start"
	 local target
	 local source
	 local sel = selection as array
	
	if sel.count > 1 do
	(
		for s in sel do
		(
			if classof s == editable_poly and s.parent == undefined then 
			(
				target = s
				print s
			)
			else if classof s == dummy then
			(
				source = s 
				print s
			)
			else
			(
				print "bouh"
			)
		)
		
		if target != undefined and source != undefined do
		(
			source.center = target.center
			print"centered"
		)
	)
	print "done"
)



rollout objReplacerRLT "objects replacer"
(
	--vars
	local modFFD
	local refObj = undefined
	local targetArr = undefined
	-- function
	
	fn checkReferenceFn =
	/*
	function to sheck the selection. the selection must be unique with one ffd box modifer.
	param: none
	return: node
	*/
	(
		sel = selection as array
		if (sel.count == 1) then
		(
			local correctFFD = False
			for modTmp in sel[1].modifiers do
			(
				if classof modTmp == FFD_2x2x2 do
				(
					correctFFD = true
					break
				)
			)
			if correctFFD == true then
			(
				return sel[1]
				print "selection conform"
			)
			else
			(
				print "your selection neeeds one ffd box"
				return undefined
			)
	
		)
		else if (sel.count > 1) then
		(
			local isgroup = False
			local tmpDummy
			
			for s in sel do 
				if (classof s == dummy) do 
				(
					tmpDummy = s
					isgroup = true
					break
				)
			
			if isgroup == true then
			(
				print "selection is a group" 
				return tmpDummy
			)
			else
			(
				return undefined
			)
		)
		
		else
		(
			print "select one object only."
			return undefined
		)
	)
	
	fn checkTargetSelectionFN =
	(
		local tgtSel = selection as array
		return tgtSel
	)
	
	-- ui
	button addRefBT "ref>>"
	edittext refnameET readonly: true
-- 	button replaceBT "replace!"

-- 	button centerBT "center selection"
	
	button replaceV2BT "replace!"
	
	-- connections
	on addRefBT pressed do
	(
		refObj = checkReferenceFn()
		if refObj != undefined then 
		(
			infoStr = stringStream ""
			format "reference selected : %"  refObj.name to: infoStr
			print(infoStr as string)
			
			refnameET.text = refObj.name
			
		)
		else 
		(
			"correct your selection"
		)
	)
	
	on replaceBT pressed do
	(
		targetArr = checkTargetSelectionFN()
		if refObj !=undefined and targetArr != undefined then
		(
			for s in targetArr do
			(
				if (s != refObj) then
				(
					print refObj
					print s
					res = replaceRefFN refObj s
					print ("result:" + res.name)
					
					res.center = s.center
				)
				else
				(
					print "reference and target are the same object"
				)
			)
		)
		else
		(
			print "check your selections."
		)
	)
	
	on centerBT pressed do
	(
		centerizeGroupFN()
	)
	
	on replaceV2BT pressed do
	(
		targetArr = checkTargetSelectionFN()
		if refObj !=undefined and targetArr != undefined then
		(
			for s in targetArr do
			(
				if (s != refObj) then
				(
					print refObj
					print s
					res = replaceRefDef refObj s
					print ("result:" + res.name)
					
					res.center = s.center
				)
				else
				(
					print "reference and target are the same object"
				)
			)
		)
		else
		(
			print "check your selections."
		)
	)
	
)
createdialog objReplacerRLT
