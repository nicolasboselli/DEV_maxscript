-- maj:
-- add uvwMapAutoFit on panel
-- create plane


try(destroyDialog opaRLT)catch()
rollout opaRLT "plan manipulator"
(
	struct planClass 
	(
		obj,
		difmap = obj.material.diffusemap.filename
		
	)
	
	fn returnBitmapDef s =
	(
		return s.material.diffusemap.filename
	)
-- vars
	local opaVal = 60
	local sel = selection as array
	local bitmapVar
-- fn
-- UI
	group "map info:" 
	(
		editText mapName_et "map name:" readOnly: true fieldWidth: 200 
		button refreshMap_bt "refresh" across:2
		button openFolder_bt "open folder"
	)
	
	group "opacity:"
	(
		spinner opaVarSP "opacity: "  range: [0,100,opaVal]  across: 3
		button opa60BT "opa 60"  
		button opa100BT "opa 100" 
	)
	
	group "transform:"
	(
		-- import rotater
	)
	
-- actions
	on refreshMap_bt pressed do
	(
		sel = selection as array
		if sel.count == 1 then
		(
			for s in sel do
			(
				bitmapVar = returnBitmapDef s
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
			foldToOpen = getFileNamePath bitmapVar
			print foldToOpen
			doscommand ("explorer " + foldToOpen)
		)

	)
		
	on opaVarSP changed val do
	(
		opaVal = val
	)
	
	on opa60BT pressed do
	(
		sel = selection as array
		for s in sel do
		(
			s.material.opacity = opaVal
		)
	)
	
	
	on opa100BT pressed do
	(
		sel = selection as array
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

