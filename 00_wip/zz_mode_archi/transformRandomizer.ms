sel = selection as array

for s in sel do
(
	in coordsys local s.position.y = - 1
)

-- random position
undo on
(
	for s in sel do
	(
		in coordsys local s.position.x = random -5 5
		in coordsys local s.position.y = 0
		in coordsys local s.position.z = random -5 5
	)
)

in coordsys  $.position.x = 1
-- $.controller.position.controller.value.x

test = #toto

if test == #toto do print test
	

print "yo\rtoto"


sel = selection as array
undo on
(e
	for s in sel do
	(
		refAngle = in coordsys local s.controller.rotation as eulerangles
		in coordsys local s.controller.rotation = eulerangles refAngle.x (random -5.0 5.0) refAngle.z
	)
)


