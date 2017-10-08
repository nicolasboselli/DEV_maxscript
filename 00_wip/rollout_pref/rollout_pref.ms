/*
edgeParams = #("pos","size","addExtrusionCB", "addSweepCB", "extSizeSP", "addExtrusionCB", \
		"removeEdgeCB", "resetXformCB", "collapseXformCB", \
		"createBoxOrientCB", "xformOnBoxCB", 	"collapseXformCB2", \
		"delBoxOrientCB", "keepSelCB")
*/
		
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
			else if classof p == Array then
			(
				local completeArray = with printAllElements on p as string
				setINISetting armadasScriptsIni cat n completeArray
			)
			else
			(
-- 				setINISetting armadasScriptsIni cat n p
				format "name: %, classof: %, value: %n" n (classof p) p
			)
		)
	)
)
-- writeRolloutParams edgeToShapeRLT edgeParams



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
			if posStr.count > 0 then setDialogPos rlt (execute posStr)
		)
		else if n == "size" then
		(
			try(posStr = getINISetting armadasScriptsIni cat "size")catch(format "*** % ***\n" (getCurrentException()))
-- 			format "name: size, value: %\n"  (GetDialogSize rlt)
		)
		else
		(
			-- load controls properties
			p = getProperty  rlt n
			
			if superclassof p == RolloutControl then
			(
				local val
				try(val = getINISetting armadasScriptsIni cat n)catch(format "*** % ***\n" (getCurrentException()))
-- 				format "name: %, value: %\n" n val
				
				if classof p == checkboxcontrol and val.count > 0 then 		
				(
					p.state = val as BooleanClass
				)
				else if classof p == SpinnerControl and  val.count > 0 then
				(
					p.value = val as float
				)
				
			)
			else if classof p == Array then
			(
				local val = getINISetting armadasScriptsIni cat n
				if val.count > 1 then
				(
-- 					format "val: %, classof: %\n" val (classof val)
					local cleanAr = #()
					local tmpAr = execute val
-- 					format "tmpAr: %\n" tmpAr
					cleanAr  = for f in tmpAr where doesfileexist f collect f
-- 					setProperty  rlt n cleanAr
				)
				else 
				(
					setProperty  rlt n #()
				)
-- 				format "n:%, val:%\n" n rlt.p
			)
			else
			(
				-- load variable
				local val = getINISetting armadasScriptsIni cat n 
				format "name: %, value: %\n" n val
			)
		)
	)		
)

-- loadRolloutParams edgeToShapeRLT edgeParams

