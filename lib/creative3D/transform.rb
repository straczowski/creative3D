#require "gmath3D"
#include GMath3D

# Uses Parmeters for x, y, z if no vector is given
# mesh => TriMesh, :vector => Vector3, :x => Float, :y => Float, :z => Float
def translate(mesh, params = {})
	raise StandardError, ":mesh is nil or not a TriMesh" if (mesh.nil? || !(mesh.kind_of? TriMesh))
	raise StandardError, ":vector is not a Vector3" if not (params[:vector].kind_of? Vector3 ) and not params[:vector].nil?
	raise StandardError, "Choose :vector or :x,:y,:z to translate" if ((not params[:vector].nil?) and ( not params[:x].nil? or not params[:y].nil? or not params[:z].nil?))

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
# mesh => TriMesh, :factor => Float, :vector => Vector3, :x => Float, :y => Float, :z => Float
def scale(mesh, params = {})
	raise StandardError, ":mesh is nil or not a TriMesh" if (mesh.nil? || !(mesh.kind_of? TriMesh))
	raise StandardError, "Choose one. :factor or :x,:y,:z " if ((not params[:factor].nil?) and ( not params[:x].nil? or not params[:y].nil? or not params[:z].nil?))
	raise StandardError, ":vector is not a Vector3" if not (params[:vector].kind_of? Vector3 ) and not params[:vector].nil?
	raise StandardError, ":factor is not a Numeric" if not (params[:factor].is_a? Numeric ) and not params[:factor].nil?

	#assign Variables
	factor = params[:factor]
	vec = params[:vector].nil? ? (mesh.center) : params[:vector]
	x = y = z = 1
	if not factor.nil?
		x = y = z = factor
	else
		x = params[:x].nil? ? 1 : params[:x]
		y = params[:y].nil? ? 1 : params[:y]
		z = params[:z].nil? ? 1 : params[:z]
	end
	
	#Do Scale
	mesh = translate mesh, :vector => (vec * -1)
	new_vecs = Array.new 
	mesh.vertices.each do | vector |
		new_vecs << (Vector3.new (vector.x * x), (vector.y * y), (vector.z * z))
	end
	mesh = TriMesh.new new_vecs, mesh.tri_indices
	mesh = translate mesh, :vector => vec
end

# :vector is optional
# mesh => TriMesh, :degree => Float, :axis => Symbol/Line, :vector => Vector3
def rotate(mesh, params = {})
	raise StandardError, ":mesh is nil or not a TriMesh" if (mesh.nil? or !(mesh.kind_of? TriMesh))
	raise StandardError, ":degree is nil or not a Number" if (params[:degree].nil? or !(params[:degree].is_a? Numeric))
	raise StandardError, "Define :axis with :x, :y, :z or as a Line" if (params[:axis].nil?) or (not (params[:axis].kind_of? Symbol) and not (params[:axis].kind_of? Line))
	raise StandardError, ":vector is not a Vector3" if not (params[:vector].kind_of? Vector3 ) and not params[:vector].nil?
	raise StandardError, "Define :axis with :x, :y, :z" if (params[:axis].kind_of? Symbol) and ((params[:axis] != :x) and (params[:axis] != :y) and (params[:axis] != :z))
	raise StandardError, "No vector is allowed if Line is defined" if not (params[:vector].nil?) and (params[:axis].kind_of? Line)

	#assign Variables
	degree = params[:degree] * Math::PI / 180
	axis   = params[:axis]
	(vec = params[:vector].nil? ? (mesh.center) : params[:vector]) if axis.kind_of? Symbol

	#Do Rotation
	# Math.cos( degree * Math::PI/180 )
	if axis.kind_of? Symbol
		mesh = translate mesh, :vector => (vec * -1)
		new_vecs = Array.new
		if axis == :x 
			mesh.vertices.each do | vector |
				y = vector.y * Math.cos(degree) - vector.z * Math.sin(degree)
				z = vector.y * Math.sin(degree) + vector.z * Math.cos(degree)
				new_vecs << (Vector3.new vector.x, y, z)
			end
		elsif axis == :y 
			mesh.vertices.each do | vector |
				x = vector.z * Math.sin(degree) + vector.x * Math.cos(degree)
				z = vector.z * Math.cos(degree) - vector.x * Math.sin(degree)
				new_vecs << (Vector3.new x, vector.y, z)
			end
		elsif axis == :z 
			mesh.vertices.each do | vector |
				x = vector.x * Math.cos(degree) - vector.y * Math.sin(degree)
				y = vector.x * Math.sin(degree) + vector.y * Math.cos(degree)
				new_vecs << (Vector3.new x, y, vector.z)
			end
		end
		mesh = TriMesh.new new_vecs, mesh.tri_indices
		mesh = translate mesh, :vector => vec
	elsif axis.kind_of? Line
		vec = axis.base_point
		dir = axis.direction - vec
		x_rot = Vector3.new(0, dir.y, dir.z).angle(dir) / Math::PI / 180
		y_rot = Vector3.new(dir.x, 0, dir.z).angle(dir) / Math::PI / 180
		mesh = translate mesh, :vector => (vec * -1)
		mesh = rotate mesh, :axis => :x, :degree => -x_rot
		mesh = rotate mesh, :axis => :y, :degree => -y_rot
		mesh = rotate mesh, :axis => :z, :degree => degree
		mesh = rotate mesh, :axis => :y, :degree => y_rot
		mesh = rotate mesh, :axis => :x, :degree => x_rot
		mesh = translate mesh, :vector => vec
	end
	mesh
end


# :vector is optional
# mesh => TriMesh, :axis => Symbol, :vetor => Vector3
def mirror(mesh,params = {})
	raise StandardError, ":mesh is nil or not a TriMesh" if (mesh.nil? || !(mesh.kind_of? TriMesh))
	raise StandardError, ":axis is nil or not a Symbol" if (params[:axis].nil? || !(params[:axis].kind_of? Symbol))
	raise StandardError, ":axis should be :x :y or :z" if (params[:axis] != :x) and (params[:axis] != :y) and (params[:axis] != :z)
	raise StandardError, ":vector is not a Vector3" if not (params[:vector].kind_of? Vector3 ) and not params[:vector].nil?

	#assign Values
	axis = params[:axis]
	vec = params[:vector].nil? ? (mesh.center) : params[:vector]

	#Do Mirror
	mesh = translate mesh, :vector => (vec * -1)
	new_vecs = Array.new
	if axis == :x
		mesh.vertices.each do | v |
			new_vecs << Vector3.new( -v.x, v.y, v.z)
		end
	elsif axis == :y 
		mesh.vertices.each do | v |
			new_vecs << Vector3.new( v.x, -v.y, v.z)
		end
	elsif axis == :z
		mesh.vertices.each do | v |
			new_vecs << Vector3.new( v.x, v.y, -v.z)
		end
	end
	#Reverse Indicies!
	new_indicies = Array.new
	mesh.tri_indices.each do | i |
		new_indicies << [i[0], i[2], i[1]]
	end
	mesh = TriMesh.new new_vecs, new_indicies
	mesh = translate mesh, :vector => vec
end

# :vector is optional
#:mesh => TriMesh, :factor => Float, :axis => Symbol, :vetor => Vector3
def stretch(mesh, params = {})
	raise StandardError, ":mesh is nil or not a TriMesh" if (mesh.nil? || !(mesh.kind_of? TriMesh))
	raise StandardError, ":axis is nil or not a Symbol" if (params[:axis].nil? || !(params[:axis].kind_of? Symbol))
	raise StandardError, ":axis should be :x :y or :z" if (params[:axis] != :x) and (params[:axis] != :y) and (params[:axis] != :z)
	raise StandardError, ":vector is not a Vector3" if not (params[:vector].kind_of? Vector3 ) and not params[:vector].nil?
	raise StandardError, ":factor is not a Numeric" if not (params[:factor].is_a? Numeric ) and not params[:factor].nil?
	raise StandardError, ":factor should not be negative" if (params[:factor] < 0)

	#assign Values
	axis = params[:axis]
	factor = params[:factor]
	vec = params[:vector].nil? ? (mesh.center) : params[:vector]

	new_vecs = Array.new
	mesh = translate mesh, :vector => (vec * -1)
	new_vecs = Array.new
	if axis == :x
		mesh.vertices.each do | v |
			new_vecs << Vector3.new( (factor*v.x), v.y, v.z)
		end
	elsif axis == :y 
		mesh.vertices.each do | v |
			new_vecs << Vector3.new( v.x, (factor*v.y), v.z)
		end
	elsif axis == :z
		mesh.vertices.each do | v |
			new_vecs << Vector3.new( v.x, v.y, (factor*v.z))
		end
	end
	mesh = TriMesh.new new_vecs, mesh.tri_indices
	mesh = translate mesh, :vector => vec
end