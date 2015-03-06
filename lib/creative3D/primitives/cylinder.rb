
class Cylinder < TriMesh


	# :height => Numeric, :radius => Numeric, :position => Vector3, :segments => Numeric 
	def initialize(params = {})
		raise StandardError, ":height have to be a Numeric" if not params[:height].nil? and not (params[:height].is_a? Numeric)
		raise StandardError, ":height have to be greater than 0" if not params[:height].nil? and not (params[:height] > 0)
		raise StandardError, ":radius have to be a Numeric" if not params[:radius].nil? and not (params[:radius].is_a? Numeric)
		raise StandardError, ":radius have to be greater than 0" if not params[:radius].nil? and not (params[:radius] > 0)
		raise StandardError, ":segments have to be a Fixnum" if not params[:segments].nil? and not (params[:segments].is_a? Fixnum)
		raise StandardError, ":segments have to be greater than 2" if not params[:segments].nil? and not (params[:segments] > 2)
		raise StandardError, ":position is not a Vector3" if not params[:position].nil? and not (params[:position].kind_of? Vector3)

		height = params[:height].nil? ? 1 : params[:height]
		radius = params[:radius].nil? ? 1 : params[:radius]
		vec = params[:position].nil? ? Vector3.new(0,0,0) : params[:position]
		segments = params[:segments].nil? ? 10 : params[:segments]

		vertices = Array.new
		indices  = Array.new
		
		#Construct Bottom
		vertices[0] = Vector3.new(0, 0, 0)
		vertices[1] = Vector3.new(radius, 0, 0)
		1.upto(segments-1) do | i |
			angle = ((360/segments)*i) * Math::PI / 180
			#Z-Rotation
			x = radius * Math.cos(angle) 
			y = radius * Math.sin(angle) 
			vertices << Vector3.new(x, y, 0)
			indices  << [0, i+1, i] #clockwise
		end
		indices << [0, 1, segments]

		#Construct Top Vertices ...
		top_v = vertices.clone
		top_v.each do | v |
			vertices << Vector3.new(v.x, v.y, height)
		end

		#... and combine them to a complete Solid
		1.upto(segments-1) do |i|
			#For the Top
			indices << [(segments+1),(segments+1+i), (segments+2+i)] #counter clockwise
			#For the Sides
			indices << [i, segments+2+i, segments+1+i]
			indices << [i, i+1, segments+2+i]
		end

		#Last for the Top
		indices << [(segments+1), (segments+segments+1), (segments+2)] 
		#Last for the Side
		indices << [segments, segments+2, (segments+segments+1)]
		indices << [segments, 1, segments+2]
		## FINSISH! ##


		# translate
 		mesh = TriMesh.new vertices, indices
 		mesh = translate mesh, :vector => vec

 		super(mesh.vertices, mesh.tri_indices)
	end


end