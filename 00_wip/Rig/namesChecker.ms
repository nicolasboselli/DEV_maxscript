-- name checker


fn sortbyname v1 v2 =
(
	-- qsort <array> sortbyname
-- 	vars
	local d
	
	if ( (toLower v1.name) < (toLower v2.name)) then
		d=-1
	else
		d=1
	
--compare les numeros entre eux et les classe	
	case of
	(
		(d < 0.): -1
		(d > 0.): 1
		default: 0
	)
)


try(destroydialog nameCheckerRLT)catch()
rollout nameCheckerRLT "Names Checker:"
(
-- 	vars
	local BaseName
	local objsAr
	
	local UtoDisp = #()
	local DtoDisp = #()
	local GtoDisp = #()
	local MtoDisp = #()
	
-- 	functions
	fn refreshAr search=
	(
		UtoDisp = #()
		DtoDisp = #()
		GtoDisp = #()
		MtoDisp = #()
		
		for o in objects do
		(
			if matchpattern o.name pattern: (search + "_D_*") ignoreCase: false then  append DtoDisp o
			else if matchpattern o.name pattern: (search + "_G_*") ignoreCase: false then  append GtoDisp o
			else if matchpattern o.name pattern: (search + "*") ignoreCase: false then  append MtoDisp o
			else  append UtoDisp o
		)
		
		qsort DtoDisp sortbyname
		qsort GtoDisp sortbyname
		qsort MtoDisp sortbyname
		qsort UtoDisp sortbyname
	)
	
-- 	UI
	editText basenameET "Basename"
	listBox undefinedLB "Undefined:" height: 40 across: 4 
	listBox DLB "Droit:" height: 40
	listBox GLB "Gauche:" height: 40
	listBox MLB "Milieu:" height: 40
	
-- 	functions UI
	fn refreshUI =
	(
		undefinedLB.items = for o in UtoDisp collect o.name
		DLB.items = for o in DtoDisp collect o.name
		GLB.items = for o in GtoDisp collect o.name
		MLB.items = for o in MtoDisp collect o.name
	)
	

-- 	Actions
	on nameCheckerRLT open do
	(
		refreshAr basenameET.text
		refreshUI()
	)
	
	on basenameET changed val do
	(
		refreshAr basenameET.text
		refreshUI()
	)
	
	on undefinedLB selected id do select UtoDisp[id]
	on DLB selected id do select DtoDisp[id]
	on GLB selected id do select GtoDisp[id]
	on MLB selected id do select MtoDisp[id]

	
)
createDialog nameCheckerRLT width: 800 height: 600
