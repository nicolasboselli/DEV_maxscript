/*
convert to vr cam
*/

sel  = selection as array

for s in sel do
(
	vrCam = VRayPhysicalCamera rotation: s.rotation pos: s.position name: s.name
)


