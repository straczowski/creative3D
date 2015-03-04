require "gmath3D"
include GMath3D

# Uses Parmeters for x, y, z if no vector is given
# :mesh => TriMesh, :vector => Vector3, :x => Float, :y => Float, :z => Float
def translate(params = {})
	raise StandardError, ":mesh is nil or not a TriMesh" if (params[:mesh].nil? || !(params[:mesh].kind_of? TriMesh))
	raise StandardError, ":vector is not a Vector3" if not (params[:vector].kind_of? Vector3 ) and not params[:vector].nil?
	raise StandardError, "Choose :vector or :x,:y,:z to translate" if ((not params[:vector].nil?) and ( not params[:x].nil? or not params[:y].nil? or not params[:z].nil?))

	mesh = params[:mesh]

	#assign x, y, z
	pv = params[:vector]
	x = y = z = 0
	if not pv.nil?
		x = pv.x
		y = pv.y
		z = pv.z
	else
		x = params[:x].nil? ? 0 : params[:x]
		y = params[:y].nil? ? 0 : params[:y]
		z = params[:z].nil? ? 0 : params[:z]
	end

	#Do translation
	new_vecs = Array.new
	mesh.vertices.each do | vector |
		new_vecs << (Vector3.new (vector.x + x), (vector.y + y), (vector.z + z))
	end

	TriMesh.new new_vecs, mesh.tri_indices
end

# Choose :factor or x,y,z. :vector is optional. 
# :mesh => TriMesh, :factor => Float, :vector => Vector3, :x => Float, :y => Float, :z => Float
def scale(params = {})
	raise StandardError, ":mesh is nil or not a TriMesh" if (params[:mesh].nil? || !(params[:mesh].kind_of? TriMesh))
	raise StandardError, "Choose one. :factor or :x,:y,:z " if ((not params[:factor].nil?) and ( not params[:x].nil? or not params[:y].nil? or not params[:z].nil?))
	raise StandardError, ":vector is not a Vector3" if not (params[:vector].kind_of? Vector3 ) and not params[:vector].nil?
	raise StandardError, ":factor is not a Numeric" if not (params[:factor].is_a? Numeric ) and not params[:factor].nil?

	#assign Variables
	mesh = params[:mesh]
	factor = params[:factor]
	vec = params[:vector].nil? ? (center_of mesh) : params[:vector]
	x = y = z = 1
	if not factor.nil?
		x = y = z = factor
	else
		x = params[:x].nil? ? 1 : params[:x]
		y = params[:y].nil? ? 1 : params[:y]
		z = params[:z].nil? ? 1 : params[:z]
	end
	
	#Do Scale
	mesh = translate :mesh => mesh, :vector => (vec * -1)
	new_vecs = Array.new 
	mesh.vertices.each do | vector |
		new_vecs << (Vector3.new (vector.x * x), (vector.y * y), (vector.z * z))
	end
	mesh = TriMesh.new new_vecs, mesh.tri_indices
	mesh = translate :mesh => mesh, :vector => vec
end

#Returns the Center Point of a TriMesh as Vector3
def center_of(tri_mesh)
	raise StandardError, "This is not a TriMesh" if !(tri_mesh.kind_of? TriMesh)
	min_x = max_x = tri_mesh.vertices[0].x
	min_y = max_y = tri_mesh.vertices[0].y
	min_z = max_z = tri_mesh.vertices[0].z
	tri_mesh.vertices.each do | vec |
		min_x = [vec.x, min_x].min
		min_y = [vec.y, min_y].min
		min_z = [vec.z, min_z].min
		max_x = [vec.x, max_x].max
		max_y = [vec.y, max_y].max
		max_z = [vec.z, max_z].max
	end
	return (((Vector3.new min_x, min_y, min_z) + (Vector3.new max_x, max_y, max_z)) * 0.5)
end

# :vector is optional
# :mesh => TriMesh, :degree => Float, :axis => Symbol/Line, :vector => Vector3
def rotate(params = {})
	raise StandardError, ":mesh is nil or not a TriMesh" if (params[:mesh].nil? or !(params[:mesh].kind_of? TriMesh))
	raise StandardError, ":degree is nil or not a Number" if (params[:degree].nil? or !(params[:degree].is_a? Numeric))
	raise StandardError, "Define :axis with :x, :y, :z or as a Line" if (params[:axis].nil?) or not (params[:axis].kind_of? Symbol) or not (params[:axis].kind_of? Line)
	raise StandardError, ":vector is not a Vector3" if not (params[:vector].kind_of? Vector3 ) and not params[:vector].nil?
	raise StandardError, "Define :axis with :x, :y, :z" if (params[:axis].kind_of? Symbol) and ((params[:axis] != :x) and (params[:axis] != :y) and (params[:axis] != :z))
	raise StandardError, "No vector is allowed if Line is defined" if not (params[:vector].nil?) and (params[:axis].kind_of? Line)

	#assign Variables
	mesh   = params[:mesh]
	degree = params[:degree]
	axis   = params[:axis]
	(vec = params[:vector].nil? ? (center_of mesh) : params[:vector]) if axis.kind_of Symbol

	#Do Rotation
	new_vecs = Array.new
	if axis.kind_of? Symbol
		if axis == :x 

		elsif axis == :y 

		elsif axis == :z

		end
	elsif axis.kind_of? Line

	end

	# x is radiant
	# Math.cos( x * Math::PI/180 )
	# or Math.cos(360*Math::PI)??? <= Auf gar keinen Fall, immer ein vielfaches  von PI
end