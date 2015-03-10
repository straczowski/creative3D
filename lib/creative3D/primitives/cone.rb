
class Cone < TriMesh

	# :radius => Numeric, :height => Numeric, segments => Fixnum
	def initialize(params = {})
		raise StandardError, ":radius must be Numeric" if (not params[:radius].nil?) and (not params[:radius].is_a? Numeric) 
		raise StandardError, ":radius must be greater than 0 " if (not params[:radius].nil?) and (not params[:radius] > 0)
		raise StandardError, ":height must be Numeric" if (not params[:height].nil?) and (not params[:height].is_a? Numeric) 
		raise StandardError, ":height must be greater than 0 " if (not params[:height].nil?) and (not params[:height] > 0)
		raise StandardError, ":segments must be Numeric" if (not params[:segments].nil?) and (not params[:segments].is_a? Fixnum) 
		raise StandardError, ":segments must be greater than 0 " if (not params[:segments].nil?) and (not params[:segments] > 2)
		raise StandardError, ":position is not a Vector3" if not params[:position].nil? and not (params[:position].kind_of? Vector3)

		radius = params[:radius].nil? ? 1 : params[:radius]
		height = params[:height].nil? ? 1 : params[:height]
		segments = params[:segments].nil? ? 3 : params[:segments]
		vec = params[:position]

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
		indices  << [0, 1, segments]

		#Construct Top
		vertices << Vector3.new(0, 0, height)
		1.upto(segments-1) do |i|
			indices << [i, i+1, segments+1]
		end
		indices << [segments, 1, segments+1]

		if not vec.nil?
			mesh = TriMesh.new(vertices, indices)
			mesh = translate mesh, :position => vec
			super(mesh.vertices, mesh.tri_indices)
		else
			super(vertices, indices)
		end
	end

end