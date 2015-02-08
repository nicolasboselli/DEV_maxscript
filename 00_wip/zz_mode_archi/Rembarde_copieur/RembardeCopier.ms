-- REMBARDE COPIEUR

-- recup des modeles
toto = #()
NumRef = InstanceMgr.GetInstances $ &toto

TempColor = color (random 1 255) (random 1 255) (random 1 255)

-- clean de la selection
WorkingCopy = copy $
WorkingCopy.name = uniquename "Rembarde_"
WCModCount = WorkingCopy.modifiers.count
for i = 1 to WCModCount do
(
	deletemodifier WorkingCopy 1
)


-- application du modele a la selection
for i = 1 to (NumRef - 1) do
(
	CopyTemp = reference WorkingCopy
	CopyTemp.name = uniquename (WorkingCopy.name + "_inst_")
	copytemp.wirecolor = TempColor
	CopyTemp.material = toto[i].material
	ModifiersCount = toto[i].modifiers.count
	for j = ModifiersCount to 1 by -1 do
	(
		addmodifier CopyTemp toto[i].modifiers[j]
	)
)


