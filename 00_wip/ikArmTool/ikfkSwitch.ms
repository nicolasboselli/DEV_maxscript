ikMod = EmptyModifier name: "IKFK_Switch"

-- maj: 
	-- prevoir le scale sur 
	-- prevoir le hide/unhide des ctrls
	
-- $.position.controller.position_constraint.controller.Position_Weight_0

-- global IKFKDataTmp
attr = attributes "ikfkSwitch"
(
	
	parameters main rollout: actions
	(
		ikList type: #nodeTab tabSizeVariable:true
		ikCtrlList type: #nodeTab tabSizeVariable:true
		fkList type: #nodeTab tabSizeVariable:true
		switchList type: #nodeTab tabSizeVariable:true
		
		ikVal type:#float ui: ikFkSp default:0
		fkVal type:#float
		
		ikToFk type: #boolean default: false
		fkToIk type: #boolean default: false
		
		autoDis type: #boolean ui: autoDisCB default: false
		
		
-- 		snaps ik/fk
		on ikToFk set val do
		(
			format "ikTofk done: %\n" val
		)
		
		on fkToIk set val do
		(
			format "fkToik done: %\n" val
		)
		
		
-- 		switch ik/fk
		on ikVal set val do
		(
			format "val: %\n" val
-- 			ikVal = ikfkValq
			
			/*
			for o in switchList do
			(
				try
				(
					o.position.controller.position_constraint.controller.Position_Weight_0 = val
					o.position.controller.position_constraint.controller.Position_Weight_1 = 1 - val
						
					o.rotation.controller.orientation_constraint.controller.orientation_Weight_0 = val
					o.rotation.controller.orientation_constraint.controller.orientation_Weight_1 = 1 - val
					
					o.scale.controller.weight[1] = val*100
					o.scale.controller.weight[2] = (1 - val)*100
				)
				catch(format "exception switch: %\n" (getcurrentexception()))
			)
			*/
			
			if autoDis do
			(
				ikDisplay = true
				fkDisplay = true
				
				if ikVal == 0.0 then
				(
					ikDisplay = true
					fkDisplay = false
				)
				else if ikVal == 1.0 then
				(
					ikDisplay = false
					fkDisplay = true
				)
				else
				(
					ikDisplay = false
					fkDisplay = false
				)
				
				for o in fkList do o.ishidden = fkDisplay
-- 				for o in ikList do 	o.ishidden = ikDisplay
				for o in ikCtrlList do o.ishidden = ikDisplay
			)
		)
	)
	
	fn exportData2 =
	(
		IKFKDataTmp = #()
		for p in getPropNames this do 
		(
			try
			(
				append IKFKDataTmp #(p, (getProperty this p))
			)catch()
		)
		format "data: %\n" IKFKDataTmp
		IKFKDataTmp
	)
	
	fn importData2 =
	(
		if not IKFKDataTmp == undefined then
		(
			for obj in IKFKDataTmp do
			(
				try(setproperty this obj[1] obj[2])catch(format "ERROR:%\n" (getcurrentexception()))
			)
		)else (format "no data: % \n" $)
	)
	
	rollout actions "IK/FK:"
	(
		group "change:"
		(
			spinner ikFkSp "IK/FK:" type: #float range: [0,1,0]
		)
			
		group "snaps:"
		(
			button ikToFkBT "IK => FK"
			button fkToIkBT "FK => IK"
		)
		
		group "display:"
		(
			checkbox autoDisCB "auto display" checked: true
		)
		
		on ikToFkBT pressed do this.ikToFk = not this.ikToFk
		on fkToIkBT pressed do this.fkToIk = not this.fkToIk


		/*
		on ikToFkBT pressed do
		(
			for i = 1 to this.ikList.count do
			(
				format "ik: % => fk: %\n" this.ikList[i] this.fkList[i] 
-- 				this.ikCtrlList[i].transform = this.fkList[i].transform
				this.ikCtrlList[i].rotation = this.fkList[i].rotation
				this.ikCtrlList[i].position = this.fkList[i].position
			)
		)
		
		on fkToIkBT pressed do
		(
			for i = 1 to (this.ikList.count - 1) do
			(
				format "ik: % <= fk: %\n" this.ikList[i] this.fkList[i] 
-- 				this.fkList[i].transform = this.ikList[i].transform
				this.fkList[i].rotation = this.ikList[i].rotation
				this.fkList[i].position = this.ikList[i].position
			)
			
			this.fkList[3].rotation = this.ikCtrlList[3].rotation
			this.fkList[3].position = this.ikList[3].position
		)
		*/
	)	
	
	rollout paramRLT "parameters:"
	(
		
		group "Import /Export"
		(
			button ImpBT "Import" across:2
			button ExpBT "Export"
		)
		
-- 		button addIkChainBT ">>"
-- 		edittext ikChainET "ik chain:" readonly: true
			
		listBox FKList "FK:"
		button addFkBT "add" 
		
		listBox IKList "IK Bones:"
		button addIkBT "add" 
		
		listBox IKCtrlList "IK CTRL:"
		button addIkCtrlBT "add" 

		listBox SwitchList "Switch:"
		button addSwBT "add" across: 2
		button mapSwBT "map" 
		
		fn refreshui =
		(
			ikMod = this
			
			try (ikChainET.text = this.ikChain.name) catch()
			try(IKList.items = for o in this.ikList collect o.name)catch()
			try(IKCtrlList.items = for o in this.ikCtrlList collect o.name)catch()
			try(FKList.items = for o in this.FKList collect o.name)catch()
			try(SwitchList.items = for o in this.SwitchList collect o.name)catch()
		)
		
-- 		actions
		
		on paramRLT open do refreshUI()
		
		on ExpBT pressed do
		(
			this.exportData2()
		)
		
		on ImpBT pressed do
		(
			this.importData2()
			refreshui()
		)
		
-- 		on addIkChainBT pressed do
-- 		(
-- 			s = selection as array
-- 			if s.count == 1 and classof s[1] == IK_Chain_Object then ikMod.ikChain = $
-- 			refreshui()
-- 		)
		
		on addFkBT pressed do
		(
			ikMod.fkList  = #()
			sel = selection as array
			for s in sel do append ikMod.fkList s
			refreshui()
		)
		
		on addIkBT pressed do
		(
			ikMod.ikList  = #()
			sel = selection as array
			for s in sel do append ikMod.ikList s
			refreshui()
		)
		
		on addIkCtrlBT pressed do
		(
			ikMod.ikCtrlList  = #()
			sel = selection as array
			for s in sel do append ikMod.ikCtrlList s
			refreshui()
		)
		
		on addSwBT pressed do
		(
			ikMod.switchList  = #()
			sel = selection as array
			for s in sel do append ikMod.switchList s
			refreshui()
		)
		
		on mapSwBT pressed do
		(
			for s in this.switchList do
			(
				format "start: %\n" s
				s.position.controller.position_constraint.controller.weight[1].controller = this.ikVal.controller
				s.position.controller.position_constraint.controller.weight[2].controller = this.fkVal.controller
				format "done: %\n" s
			)
		)
	)
		
	on load do 
	(
		global IKFKDataTmp
	)
	
	on create do
	(
-- 		format "this: %\n" this.fkVal
		this.ikVal.controller = bezier_float ()
		this.fkVal.controller = float_script ()
		this.fkVal.controller.AddObject "driver" this.ikVal.controller
		this.fkVal.controller.script = "1 - driver.value"
	)
)
custAttributes.add ikMod attr
addmodifier $ ikMod

$.position.controller.position_constraint.controller.weight[1].controller = bezier_float ()

/*
obj =  $Box003
when transform obj change id: #testHandler do
(
	format "transform: %\n" obj.pos
)

deleteAllChangeHandlers id: #testHandler
*/

-- deleteAllChangeHandlers