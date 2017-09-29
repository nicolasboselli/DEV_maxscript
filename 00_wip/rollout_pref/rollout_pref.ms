
fn writeRolloutParams rlt params =
(
	local armadasScriptsIni = (GetDir #maxData) + "armadasScriptsIni.ini"
	local cat = rlt.name
	
	format "rollout: %\n" cat
	for n in params do
	(
		-- collect position
		if n == "pos" then
		(
			setINISetting armadasScriptsIni cat n  ((GetDialogPos rlt) as string)
			format "name: pos, value: %\n"  (GetDialogPos rlt)
		)
		-- collect size
		else if n == "size" then
		(
			setINISetting armadasScriptsIni cat n  ((GetDialogSize rlt) as string)
			format "name: size, value: %\n"  (GetDialogSize rlt)
		)
		else
		(
			
			p = getProperty  rlt n
			-- collect rollout control
			if superclassof p == RolloutControl then
			(
				
				if classof p == checkboxcontrol then 
				(
					setINISetting armadasScriptsIni cat p.name  (p.state as string)
					format "name: %, value: %\n" p.name p.state
				)
				else if classof p == SpinnerControl then 
				(
					setINISetting armadasScriptsIni cat p.name  (p.value as string)
					format "name: %, value: %\n" p.name p.value
				)
				else(format "UNKNOWN_param: %, classof: %\n" p (classof p))
				
			)
			-- collect variable
			else
			(
				setINISetting armadasScriptsIni cat n p
				format "name: %, value: %\n" n p
			)
		)
	)
)

fn loadRolloutParams rlt params =
(
	local armadasScriptsIni = (GetDir #maxData) + "armadasScriptsIni.ini"
	local cat = rlt.name
	
	for n in params do
	(
		if n == "pos" then
		(
			local posStr
			try(posStr = getINISetting armadasScriptsIni cat "pos")catch(format "*** % ***\n" (getCurrentException()))
			if SposStr.count > 0 then setDialogPos rlt (execute posStr)
		)
		else if n == "size" then
		(
			sizeStr = getINISetting armadasScriptsIni cat "size"
		)
		else
		(
			p = getProperty  rlt n
			if superclassof p == RolloutControl then
			(
				try(val = getINISetting armadasScriptsIni cat p)catch(format "*** % ***\n" (getCurrentException()))
				format "name: %, value: %\n" n p
			)
			else
			(
				getINISetting armadasScriptsIni cat n 
				format "name: %, value: %\n" n p
			)
		)
	)		
)

edgeParams = #("pos","size","addExtrusionCB", "addSweepCB", "extSizeSP", "addExtrusionCB", "removeEdgeCB", "resetXformCB", "collapseXformCB")

writeRolloutParams edgeToShapeRLT edgeParams

loadRolloutParams edgeToShapeRLT edgeParams