-- conversion de la selection en edge
$.EditablePoly.ConvertSelectionToBorder #Face #edge
subobjectLevel = 2

-- recupération de la selection d'edge
$.EditablePoly.ConvertSelection #border #Edge
subobjectLevel = 2
edge_select = 
$.EditablePoly.GetSelection #Edge

$.EditablePoly.GetSelection #face
-- pour chaque edge convertir la selection en vertex
-- enregistrer la selection de vertex


$.EditablePoly.resetEdgeData

-- conversion de la selection en vertex
$.EditablePoly.ConvertSelection #Edge #Vertex
subobjectLevel = 1

-- retrouver un vertex à partir de 2 edges
$.EditablePoly.GetEdgeVertex 1 2
$.EditablePoly.setselection #edge #{1,2}

-- enregistrement de la selection de vertex
vertex_select = $.EditablePoly.GetSelection #vertex
vertex_array = vertex_select  as array
vertex_num = vertex_array.count

-- enregistrement des positions des vertex
vertex_pos = for i = 1 to vertex_num collect $.selectedVerts[i].pos
	
-- classemennt des vertex

-- création  de la spline
sweep_line = splineshape ()
addNewSpline  sweep_line

for i = 1 to vertex_pos.count do
(
addKnot sweep_line 1 #corner #line vertex_pos[i]
)

updateshape sweep_line

close sweep_line 1

updateshape sweep_line
select sweep_line

-- ajout du sweep

modPanel.addModToSelection (sweep ()) ui:on
$.modifiers[#Sweep].CurrentBuiltInShape = 2
$.modifiers[#Sweep].CustomShapeName = ""
$.modifiers[#Sweep][#Bar_Section].length = 20
$.modifiers[#Sweep][#Bar_Section].width = 20
$.modifiers[#Sweep][#Bar_Section].cornerRadius = 0
$.modifiers[#Sweep].PivotAlignment = 8
$.modifiers[#Sweep].SmoothPath = off

	
-- ajout de uvwmap
modPanel.addModToSelection (Uvwmap ()) ui:on
$.modifiers[#UVW_Mapping].maptype = 4
$.modifiers[#UVW_Mapping].length = 250
$.modifiers[#UVW_Mapping].width = 250
$.modifiers[#UVW_Mapping].height = 250

