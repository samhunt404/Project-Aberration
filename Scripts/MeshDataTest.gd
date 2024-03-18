extends SoftBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var arrMesh := ArrayMesh.new()
	arrMesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,mesh.surface_get_arrays(0))
	var mdt := MeshDataTool.new()
	var meshArr := PackedInt32Array([])
	
	mdt.create_from_surface(arrMesh,0)
	for i in range(0,mdt.get_vertex_count()):
		if(mdt.get_vertex_bones(i)[0] > 0):
			meshArr.append(i)
			set_point_pinned(i,false)
		else:
			set_point_pinned(i,true)

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta : float) -> void:
	pass
