
 macroScript sc_toggleBoneDisplay 
category:"scrimskiUI" 
Buttontext:"Toggle Bone Display" 
tooltip:"Toggle Bone Display" 


(     
    on execute do 
    ( 
		bakSel = $selection as array 
		hideByCategory.bones = NOT ( hideByCategory.bones )
		select ($* as array)
		select bakSel                     
    )     
) 