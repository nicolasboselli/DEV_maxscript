
struct trio 
(
	freeCtrl,
	machineCtrl,
	splineHlp,
	fn isOk =
	(
		res = false
		try
		(
			if freeCtrl.pos.y == machineCtrl.pos.y and freeCtrl.pos.y == splineHlp.pos.y then res = true
		)catch()
		res
	)
)

trioAr = #()
-- collect free control
free_ctrl = for c in $tuyau_ctrl_hlp.children collect c
-- collect machine control
machine_ctrl = for c in  $tuyau_to_machine_ctrl_hlp.children collect c
-- collect helper
spline_hlp = for c in $tuyau_spline_ctrl.children collect c
	
free_ctrl[1].pos.y
-- make trio 
if free_ctrl.count == machine_ctrl.count and  free_ctrl.count == spline_hlp.count then
(
	print "good count"
	for i = 1 to free_ctrl.count do
	(
		oneTrio = trio()
		oneTrio.freeCtrl = free_ctrl[i]
		
		-- find first position value in free_ctrl
		refPosY = free_ctrl[i].pos.y

		-- look for value in machine_ctrl
		for mc in machine_ctrl where mc.pos.y == refPosY do
		(
			oneTrio.machineCtrl = mc
		)

		-- look for value in spline_hlp
		for sh in spline_hlp where sh.pos.y == refPosY do
		(
			oneTrio.splineHlp = sh
		)
		
		if oneTrio.isOk()== true then
		(
			append trioAr oneTrio
		)
	)
)
else (print "bad count")

-- on each trio find controls and helper
for trio in trioAr do
(
	format "trio: %\n" trio
	-- on helper add position control list and orienattion control list
	-- on helper add parameters free/machine
	-- conect free parameter to machine parameter
	-- connect parameters to constraint weight	
)

toto = $toto
tata1 = $tata1
tata2 = $tata2

-- add position constraint
toto.position.controller = Position_XYZ ()
toto.position.controller = position_list ()
toto.position.controller.available.controller = position_constraint ()
toto.position.controller.position_constraint.controller.appendTarget tata1 100
toto.position.controller.position_constraint.controller.appendTarget tata2 100

-- add parameters
the_attr = attributes  attr
(
	parameters main rollout:params
	(
	hitPoints type: #float ui:hits default:10
	cost type: #float ui:cost default:100
	sound type: #string
	)
	
	rollout params "Weapon Parameters"
	( 
	spinner hits "Hit Points" type: #float
	 spinner cost "Cost" type: #float
	  dropdownlist sound_dd "Sound" items:# ("boom","sparkle","zap","fizzle")
	 )

)

custAttributes.add toto the_attr
the_attr