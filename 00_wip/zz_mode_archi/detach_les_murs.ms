

face_select = $.EditablePoly.GetSelection #Face 
face_count = $.EditablePoly.GetNumFaces ()
face_array = #{}
for i = 1 to face_count do append face_array i

face_invert = face_array - face_select

subobjectLevel = 0

copy_mesh = copy $
select copy_mesh

modPanel.setCurrentObject $.baseObject
subobjectLevel = 4

$.EditablePoly.SetSelection #Face face_invert
$.EditablePoly.delete #Face 

face_count2 = $.EditablePoly.GetNumFaces ()
face_array2 = #{}
for i = 1 to face_count2 do append face_array2 i

$.EditablePoly.SetSelection #Face face_array2

$.outlineAmount = -5

subobjectLevel = 0
$.EditablePoly.GetNumFaces ()

subobjectLevel = 4
test = $.EditablePoly.GetSelection #Face 
$.EditablePoly.SetSelection #Face test

$.outlineAmount = -5
$.EditablePoly.Outline ()

subobjectLevel = 0
modPanel.addModToSelection (Shell ()) ui:on
$.modifiers[#Shell].innerAmount = 2
$.modifiers[#Shell].outerAmount = 2
