-- InstanceMgr.GetInstances $ &instances

-- select instances

fn getInstancesFN sel = 
(
	InstanceMgr.GetInstances sel &instances
	if instances.count<=1 do print "no instances"
	select instances
)

fn randomColorFN sel =
(
	randomColor = color (random 0 255) (random 0 255) (random 0 255)
	sel.wirecolor =  randomColor
)
random 0 255
rollout miscRLT "misc"
(
	button getInstBT "get instances"
	button randColBT "random color"
	
	on getInstBT pressed do
	(
		sel = $selection as array
		if sel.count == 1 do
		(
			getInstancesFN sel[1]
		)
			
	)
	
	on randColBT pressed do
	(
		sel = $selection as array
		for s in sel do
		(
			randomColorFN s
		)
		
	)
)
createDialog miscRLT