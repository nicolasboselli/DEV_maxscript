sizze = 160

if $selection.count == 1 then
	
(
	$.modifiers[#UVW_Mapping].length = sizze
	$.modifiers[#UVW_Mapping].width = sizze
	$.modifiers[#UVW_Mapping].height = sizze
)

else

(
	s = $ as array
	
	for o in s do
		(
		o.modifiers[#UVW_Mapping].length = sizze
		o.modifiers[#UVW_Mapping].width = sizze
		o.modifiers[#UVW_Mapping].height = sizze
		)
)