-- $.EditablePoly.detachToElement #Face keepOriginal:on
-- $.EditablePoly.detachToElement #Face keepOriginal:false

objSel = $selection as array

-- obj = polyop.getFaceSelection $
--faceSel = polyop.getFaceSelection objSel[1]

newName = uniqueName( objSel[1].name + "_part")
-- detach faces
polyop.detachFaces objSel[1] #selection delete: false asNode: true name: newName


-- outline faces of new object
newNode = getnodebyname newName
select newNode

polyop.setFaceSelection newNode #all
newNode.outlineAmount = 5
newNode.EditablePoly.Outline ()

-- add shell on object
myShell = Shell innerAmount:2 outerAmount:2
addmodifier newNode myShell	

appui
-- material
if sceneMaterials["appui"] == undefined then
(
	appui = Standard name: "appui"
)
else
(
	appui = sceneMaterials["appui"]
)
newNode.material = appui