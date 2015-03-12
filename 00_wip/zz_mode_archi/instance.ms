

fn cleancombine grp =
(
	master = grp[1]
	converttopoly master
	InstanceMgr.MakeObjectsUnique master #individual

	for i = grp.count to 2 by -1 do
	(
		master.EditablePoly.attach grp[i] master
	-- 	print sel[i]
	)
	return master
)

sel = $selection as array
cleancombine sel