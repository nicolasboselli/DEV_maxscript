-- maj:
-- add uvwMapAutoFit on panel
-- create plane

rollout opaRLT "selection opacity"
(
	

-- vars
	local opaVal = 60
	local sel = $selection
	local bitmapVar
-- fn
-- UI
	editText mapName_et "map name:" readOnly: true fieldWidth: 50
	button refreshMap_bt "refresh" across:2
	button openFolder_bt "open folder"
	spinner opaVarSP "opacity: "  range: [0,100,opaVal]  across: 3
	button opa60BT "opa 60"  
	button opa100BT "opa 100" 
	
-- actions
	on refreshMap_bt pressed do
	(
		sel = $selection
		if sel.count == 1 then
		(
			for s in sel do
			(
				bitmapVar = s.material.diffusemap.filename
				mapName_et.text = bitmapVar
			)
		)
		else
		(
			print"bad selection"
		)
	)
	
	on openFolder_bt pressed do
	(
		if bitmapVar != undefined do
		(
			folder = getFileNamePath bitmapVar

			var = stringstream ""
			format "explorer %" folder to: var
			doscommand (var as string)
		)

	)
		
	on opaVarSP changed val do
	(
		opaVal = val
	)
	
	on opa60BT pressed do
	(
		sel = $selection
		for s in sel do
		(
			s.material.opacity = opaVal
		)
	)
	
	
	on opa100BT pressed do
	(
		for s in sel do
		(
			
			s.material.opacity = 100
		)
	)
	
	on opaRLT resized size do
	(
		print "resized"
		width =  size[1]
		print width
		mapName_et.width = width - 100
	)
)



createdialog opaRLT  width: 300 style: #(#style_resizing,#style_titlebar, #style_border, #style_sysmenu,#style_minimizebox, #style_maximizebox )

