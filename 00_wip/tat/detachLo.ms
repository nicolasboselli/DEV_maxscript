tag = "Queue_16"


nameAr = filterString  s.name "_"
newname = nameAr[1] + "_" + nameAr[2] + "_" + tag + "_"  + nameAr[3]

face = polyop.getFaceSelection s
elt = polyop.getElementsUsingFace s face
polyop.detachFaces s elt delete: true asNode: true name: newname 

eltsAr = #()
facesNum = polyop.getNumFaces s 
for i = 1 to facesNum do
(
	elt = polyop.getElementsUsingFace s #{i}
	appendifunique eltsAr elt
)

i = 0

s = $

elt = polyop.getElementsUsingFace s 1

basename = substitutestring  s.name "_LO" ""
objName = basename + "_"+ "obj"+ (i as string) +  "_LO"

polyop.detachFaces s elt delete: true asNode: true name: objName
res = getnodebyname "objTmp"
i +=1


