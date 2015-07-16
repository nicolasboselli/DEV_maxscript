sel = selection as array

planes = for s in sel where (classof s) == plane or classof s == editable_mesh collect s
select planes