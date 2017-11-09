-- $.scale

rep = $r*_bat as array
rep.count

-- b = $Box13701

b = $
firstDone = false
lastDone = false
for i = 1 to ( rep.count + 1 )do
(
	if i <= rep.count and i > 1 then
	(
		b2 = copy b
		b2.name = b.name +"_r" +  (i as string)
		
		sl = SliceModifier name: "delete_down" Slice_Type:3
		addmodifier b2 sl
		b2.modifiers["delete_down"].slice_plane.position.z = in coordsys b rep[i - 1].position.z
			
		sl = SliceModifier name: "delete_up" Slice_Type:2
		addmodifier b2 sl
		b2.modifiers["delete_up"].slice_plane.position.z = in coordsys b rep[i].position.z
		
		l = layermanager.getLayerFromName  rep[i].name
		l.addnode b2
	)
	else if i == 1 then
	(
		b1 = copy b
		b1.name = b.name +"_r" +  (i as string)
		
		sl = SliceModifier name: "delete_up" Slice_Type:2
		addmodifier b1 sl
		b1.modifiers["delete_up"].slice_plane.position.z = in coordsys b rep[i].position.z
			
		l = layermanager.getLayerFromName  rep[i].name
		l.addnode b1
	)
	else if i == (rep.count + 1) then
	(
		b3 = copy b
		b3.name = b.name +"_r" +  (i as string)
		
		sl = SliceModifier name: "delete_down" Slice_Type:3
		addmodifier b3 sl
		b3.modifiers["delete_down"].slice_plane.position.z = in coordsys b rep[i - 1].position.z
			
-- 		l = layermanager.getLayerFromName  rep.name
-- 		l.addnode b3
	)
		
)

-- l = layermanager.getLayerFromName  "r01_bat"
-- l.addnode $

b.boxmode = true

/*
for i = 1 to rep.count do
(
	raySize
	baseRay = polyop.getSlicePlane b size:&raySize
	baseRay.position.z = rep[i].position.z

-- 	polyop.setSlicePlane b baseRay raySize
	polyop.slice b #all baseRay
)
redrawViews ()
*/