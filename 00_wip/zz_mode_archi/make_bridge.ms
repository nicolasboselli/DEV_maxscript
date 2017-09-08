-- createur de pont

-- à partir du'une selection de deux edges sur le même plan
s = $
edgeSel  = polyop.getEdgeSelection s -- ) as array


-- trouver les vertex selectionnés
firstVx = #()
for i in edgeSel do 
(
	tmpVx = polyop.getEdgeVerts s i
	firstVx += tmpVx
)

-- trouver les faces concernées
faces = #()
for i in edgeSel do 
(
-- 	print i
	tmpfaces = polyop.getEdgeFaces  s i
	format "faces:%\n" faces
	faces += tmpFaces
)
polyop.setfaceselection s  faces
redrawviews ()

 
-- trouver les vertex des faces concernées
verts = #()
for i in faces do
(
	tmpVerts = polyop.getFaceVerts  s  i
	for i in tmpVerts do appendifunique verts i
)

-- supprimer les vertex selectionner initialement de la selection finale.
restVxBit = verts as bitarray - firstVx as bitarray

-- associer les vertex qui n'ont pas d'edges en commun
restVx = restVxBit as array
for i in restVx do
(
	for j in restVx do
	(
		ed  = s.editablePoly.GetVertexEdge  i j
		format "i:%, j:%, edge:%\n" i j ed
	)
)

$.editablePoly.GetVertexEdge 3 4