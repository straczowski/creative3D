
class RForm < TriMesh

	# :segments => Fixnnum, :last_line_rotate => Boolean
	def initialize(vecs2, params = {})
		raise StandardError, ":segments have to be a Fixnum" if not params[:segments].nil? and not (params[:segments].is_a? Fixnum)
		raise StandardError, ":segments have to be greater than 2" if not params[:segments].nil? and not (params[:segments] > 2)
		
		segments = params[:segments].nil? ? 10 : params[:segments]

		vertices = Array.new
		indices = Array.new

		vecs2.each do |v|
			vertices << (Vector3.new v[0], v[1], 0)
		end

		#bring rotate Line to V3(0,1,0)
		vec_trans = vertices[0]
		angle = (vertices.last - vec_trans).angle(Vector3.new(0, 1, 0))
		vertices_new = Array.new
		vertices.each do | v |
			t = v - vec_trans
			x = t.x*Math.cos(angle)-t.y*Math.sin(angle)
			y = t.y*Math.cos(angle)+t.x*Math.sin(angle)
			vertices_new << Vector3.new(x, y, 0)
		end
		vertices = vertices_new.clone
		
		last = vertices.pop
		#Rotate for segments
		1.upto(segments-1) do | s |
			degree = ((360/segments)*s) * Math::PI / 180
			#Y-Rotation
			1.upto(vecs2.length-2) do | i |
				x = vertices[i].z * Math.sin(degree) + vertices[i].x * Math.cos(degree)
				z = vertices[i].z * Math.cos(degree) - vertices[i].x * Math.sin(degree)
				vertices << Vector3.new(x, vertices[i].y, z)
			end
		end
		vertices << last

		#Build Indices
		j = vecs2.length-2
		0.upto(segments-1) do |s|
			1.upto(vecs2.length-3) do |i|
				if s == (segments-1)
					indices << [ (j*s)+i, i,  (j*s)+i+1 ]
					indices << [ i,       i+1,(j*s)+i+1 ]
				else
					indices << [ (j*s)+i,     (j*(s+1))+i,  (j*s)+i+1 ]
					indices << [ (j*(s+1))+i, (j*(s+1))+i+1,(j*s)+i+1 ]
				end
			end
			#Bottom and top
			if s == (segments-1)
				indices << [0, 1, j*s+1]
				indices << [j, vertices.length-1,j*s+j]
			else
				indices << [0, j*(s+1)+1, j*s+1]
				indices << [j*(s+1)+j, vertices.length-1,j*s+j]
			end
		end

		puts "Count Triangles: "+indices.length.to_s
		puts "indices " +indices.to_s
		puts "vertices: "+vertices.length.to_s
		#20.times do
		#	vertices << Vector3.new(0,0,0)
		#end

		super(vertices, indices)
	end
end