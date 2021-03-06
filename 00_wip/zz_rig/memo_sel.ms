rollout memoRlt "Object Memo"
(
-- 	vars
	local memoSelAr = #()
-- 	UI 
	multilistbox memoSelMBX "Memo selection"
	button addSelBt "ajouter � la m�moire"
	button clearBT "nettoyer la m�moire"
	
	group "trouver les instances � partir de la selection... "
	(
		button findInstFromListBT "...dans la liste"  across: 2
		button findInstFromSceneBT "...dans la sc�ne"
	)
	
	group "selectionner dans la sc�ne..."
	(
		button selSelBt "... la selection dans la liste" across: 2
		button selAllBT "...toute la liste"
	)
	
	group "supprimer de la m�moire la s�lection..."
	(
		button delInArBT "...dans la liste " across: 2
		button delFromScenBT "...dans la sc�ne"
	)
	
-- 	events
	on memoRlt open do
	(
		memoSelMBX.items = for o in memoSelAr collect o.name
	)
	
	on findInstFromSceneBT pressed do
	(
		selAr = $selection  as array
		if selAr.count == 1 then
		(
			for o in selAr do InstanceMgr.GetInstances o &boxInstances
		)
		else
		(
			print "selectionner un seul objet"
		)
		select boxInstances
		
	)
	
	on addSelBt pressed do
	(
		sel = $selection as array
		for o in sel do append memoSelAr o
		memoSelAr = makeuniqueArray memoSelAr
		memoSelMBX.items = for o in memoSelAr collect o.name
	)
	
	on clearBT pressed do
	(
		memoSelAr = #()
		memoSelMBX.items = for o in memoSelAr collect o.name
	)
	
	on memoSelMBX selectionEnd do
	(
		selBitAr = memoSelMBX.selection
		print ((selBitAr as array) as string)
	)
	
	on selSelBt pressed do
	(
		selAr =  memoSelMBX.selection as array
		selToSelAr = for o in selAr collect memoSelAr[o]
		select selToSelAr
	)
	
	on selAllBT pressed do
	(
		select memoSelAr
	)
	
	on delInArBT pressed do
	(
		selAr =  memoSelMBX.selection as array
		for i = 1 to  selAr.count do deleteitem memoSelAr selAr[1]
		memoSelMBX.items = for o in memoSelAr collect o.name
	)
	
	on delFromScenBT pressed do
	(
		selInSceneAr = $selection as array
		for o in selInSceneAr do 
		(
			for i = 1 to memoSelAr.count do
			(
				if (o  ==  memoSelAr[i]) then
				(
					deleteitem memoSelAr i
					memoSelMBX.items = for o in memoSelAr collect o.name
				)
				else
				(
					print "pas de pr�sence dans la m�moire"
				)
			)
		)
		
	)
)

createdialog memoRlt width: 400