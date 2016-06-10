-- todo: améliorer le calcul des poids à l'approche de 0 et de 1
-- faire les calculs sur 1000 en int



fn getSkinVertSel m =
(
	vxCount = skinOps.GetNumberVertices m
	local vxSelAr = for i = 1 to vxcount where skinops.IsVertexSelected m i == 1 collect i
	vxSelAr
)

fn majOneVertex m majoredBone unLockedBoneList  vx wtAdd =
(
	
	/* Collecte du set bones et de poids */
	-- collecter la liste de bones et la liste de poids correspondants
	vxMaxBones = skinOps.GetVertexWeightCount m vx
	bnList = #()
	wtList = #()
	
	for i = 1 to vxMaxBones do
	(
		append bnList (skinOps.GetVertexWeightBoneID m vx i)
		append wtList (skinOps.GetVertexWeight m vx i)
	)
	#(bnList, wtList)
-- 	format "vertex: %, bones: %, weights: % \n" vx bnList wtList


	/* Check du set sur lequel travailler*/
	boneMajoredUnlocked = False
	-- tester si le bone à majorer est delocké
	res = finditem unLockedBoneList majoredBone
	if res > 0 then boneMajoredUnlocked = true
	
	-- tester si le bone majorer est déja une influence du vertex
	mbiId = finditem bnList majoredBone
	majoredCorrect = False
	if mbiId > 0 and  boneMajoredUnlocked == true then 
	(
		majoredCorrect = True
-- 		format "bone majored: %, initial weight: %\n" bnList[mbiId] wtList[mbiId]
	)
	else if mbiId == 0 and  boneMajoredUnlocked == true then
	(
		append bnList majoredBone
		append wtList 0
		mbiId = bnList.count
		majoredCorrect = true
-- 		format "bone majored added : %, initial weight: %\n" bnList[mbiId] wtList[mbiId]
	)
	else
	(
		format "the selected bone is locked: %\n" majoredBone
	)
	
	-- collecter les bones sur lesquels on enlève du poid
	minoredCorrect = False
	minoredBnList = #()
	minoredWtList = #()
	minoredBnIdList = #()
	for i = 1 to bnList.count do
	(
		if bnList[i] != majoredBone and (finditem unLockedBoneList bnList[i]) > 0 then
		(
			append minoredBnList bnList[i]
			append minoredWtList wtList[i]
			append minoredBnIdList i
		)
		if minoredBnList.count >= 1 then minoredCorrect = True
	)
-- 	format "minored bones: % ,  initial weight: %\n" minoredBnList minoredWtList
	
	


	/* test du poids à ajouter */
	if majoredCorrect== true then majoredBoneWt = wtList[mbiId]
		-- prévoir que l'addition arrive à 0 ou à 1 sur le bone majorée et laisse un reste:
			-- permettre l'addition, soustraire le reste de l'influence à repartir sur les autres bones
	
	-- prévoir que la compensation arrive à 0 ou à 1 sur un bone minoré et laisse un reste:
			-- répartir ce reste sur les autre bones disponible
	
	
	-- majoration
	additionDone = False
	-- si le bone à majorer est correct et si les bone à minorer son correct
	if majoredCorrect == true and minoredCorrect == true  then 
	(
		-- tester si la valeur majorée est comprise entre 0 et 1
		if (wtList[mbiId] + wtAdd) > 0 and (wtList[mbiId] + wtAdd) < 1 then
		(
-- 			ADDITION
-- 			si le bone est présent dans les influences, ajouter le poids
-- 			format "vertex: %, bone majored: %, weight initial:% \n" vx majoredBone wtList[mbiId] 
			wtList[mbiId] += wtAdd
			
-- 			format "vertex: %, bone majored: %, weight majored:% \n" vx majoredBone wtList[mbiId]
			
-- 			COMPENSATION
			minorWt = wtAdd / minoredBnList.count
			for id in minoredBnIdList do
			(
				wtList[id] -= minorWt
			)
			
			additionDone = True
		)
-- 		else (format "vertex: %, bone: %, addition impossible, valeur butoir atteinte\n" vx majoredBone ) 
	)
-- 	else (format "vertex: %, bone majored: %, bones minored: %, addition impossible\n" vx majoredBone minoredBnList ) 

	-- compensation
	if additionDone == True then 
	(
-- 		format "vertex: %, bones:%, weight: % \n\n" vx bnList wtList 
		skinOps.ReplaceVertexWeights m vx bnList wtList
	)
	
			-- diviser le poids ajouter en autant de bones collecter
			-- retrancher le poids au poids des bones delockés (repartition égale)
			-- retrancher le poids au poids des bones delockés (repartition proportionné)
	
		-- enlever tout ce poids uniquement au vertex delockés
)

try(destroydialog addWtRLT)catch()
rollout addWtRLT "Addition Weight"
(
	local wtAdd
	local m 
	local skinMaxBones 
	local unLockedBoneList 
	local majoredBone
	local vxSelAr
	local parentRLT
	
	spinner wtSP "weight:" range: [0,1,0.1] type: #float
	button majWtBT "+" across: 2
	button minWitBT "-"
	button testBT "test"
	
	on majWtBT pressed do
	(
		wtAdd = wtSP.value
		m = modPanel.getCurrentObject() 
		skinMaxBones = skinOps.GetNumberBones m
-- 		unLockedBoneList = for i = 1 to skinMaxBones collect i
		unLockedBoneList = for o in parentRLT.skinBonesAr where o.isLocked == false collect o.id
		majoredBone = skinOps.GetSelectedBone m
		vxSelAr = getSkinVertSel m
		format "unLockedBoneList: %, majoredBone:%\n" unLockedBoneList majoredBone
		for vx in vxSelAr do	majOneVertex m majoredBone unLockedBoneList  vx wtAdd 
	)
	
	on minWitBT pressed do
	(
		wtAdd = wtSP.value
		m = modPanel.getCurrentObject() 
		skinMaxBones = skinOps.GetNumberBones m
-- 		unLockedBoneList = for i = 1 to skinMaxBones collect i
		unLockedBoneList = for o in parentRLT.skinBonesAr where o.isLocked == false collect o.id
		majoredBone = skinOps.GetSelectedBone m
		
		vxSelAr = getSkinVertSel m
		
		for vx in vxSelAr do	majOneVertex m majoredBone unLockedBoneList  vx (wtAdd*-1)
	)
	
	on testBT pressed do
	(
		bonesUnlocked = for o in parentRLT.skinBonesAr where o.isLocked == false collect o.id
		format "test: %\n" bonesUnlocked
	)
)
-- createdialog addWtRLT
