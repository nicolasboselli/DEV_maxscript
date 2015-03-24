

--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
	

	if selection.count != 0 then
	(
		if (modPanel.getCurrentObject() == undefined) then  max modify mode
		
		case of
		(
		-- en cas de selection d'éléments
			(subobjectLevel == 5) :
			(
			s = $

			detach_elements_selected s

				for o in fenetres_array do 
				(	
					select o
					-- en cas de selection d'objet fenetres bases
					if (o.EditablePoly.GetNumFaces ()) > 10 then 
					(
						clean_une_fenetre o
						FlipAllNormals o
					)
						
					vectors_by_matrix o
					redress_pivot o
					--redress_pivot o

					--edgesVariables o
					VertexSorting o
					RecreateEdgeY o
					RecreateEdgeX o
				)
				
				select fenetres_array
				first = fenetres_array[1]
				for i = 2 to fenetres_array.count do first.editablePoly.attach  fenetres_array[i] first
				first.name = (uniquename "fenetre_bases")
				
				temp = getNodeByname first.name
				temp.material = undefined
				
			)
			
		-- en cas de selection au niveau objet
		
			(subobjectLevel == 0):
			(
				s_array = $selection as array
				
				for s in s_array do
				(
					-- selectionne toutes les faces de l'objet
					select s
					polyop.setFaceSelection s #all

					detach_elements_selected s

					for o in fenetres_array do 
					(
						select o
						-- en cas de selection d'objet fenetres bases
						if (o.EditablePoly.GetNumFaces ()) > 10 then 
						(
							clean_une_fenetre o
							FlipAllNormals o
						)
							
						vectors_by_matrix o
						redress_pivot o
						--redress_pivot o

						--edgesVariables o
						VertexSorting o
						RecreateEdgeY o
						RecreateEdgeX o
					)
					
					select fenetres_array
					first = fenetres_array[1]
					for i = 2 to fenetres_array.count do first.editablePoly.attach  fenetres_array[i] first
					first.name = (uniquename "fenetre_bases")
					
					temp = getNodeByname first.name
					temp.material = undefined
					
				)
			)
			
			-- dans tous les autres cas de selection
			default: print "selectionner des objets ou des elements d'objet"
			
		)
	
	)
	else print "selectionner des objets ou des elements d'objet"

