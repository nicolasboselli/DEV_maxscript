objs = objects as array

for o in objs where classof o == railclone_pro do
(
	o.vmesh = 0
)

for o in objs where classof o == railclone_pro do
(
	converttopoly o
)


objs = objects as array
for o in objs where o.modifiers.count >= 1 do
(
	for m in o.modifiers where classof m == sweep do
	(
		format "obj: %, mod: %\n" o m
		converttopoly o
	)
)
	

objs = objects as array
for o in objs where o.modifiers.count >= 1 do
(
	for i = 1 to o.modifiers.count where classof o.modifiers[i] ==  meshsmooth do
	(
		format "obj: %, mod: %\n" o m
-- 		converttopoly o
		deletemodifier o i
	)
)
	

