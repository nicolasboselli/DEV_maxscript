fn InstanceMatByName mat = (
	(for o in objects where o.mat != undefined and o.mat.name == mat.name collect o).mat = mat
)
 
--example usage:
InstanceMatByName (meditMaterials[1])


