sel = selection as array

rc = sel[1]

for i = 2 to sel.Count do
(
	l = sel[i]
	
		-- copy railclone
	new = copy rc
	-- assign new spline
	new.banode[1] = l

	-- realign railclone
	new.transform = copy l.transform

	-- re assign line
	new.banode[1] = l
	
	-- realign railclone
-- 	new.transform = copy l.transform
	new.disabled = on
	redrawviews ()
	
	new.disabled = off
	redrawviews ()
	

)



/*
sp = $.banode[1]

$.transform = sp.transform

	redrawViews ()
*/