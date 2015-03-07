
class Sphere < TriMesh

	# :radius => Numeric, :longitudes => Numeric, :latitudes => Numeric, :position => Vector3
	def initialize(params = {})
		raise StandardError, ":radius have to be a Numeric" if not params[:radius].nil? and not (params[:radius].is_a? Numeric)
		raise StandardError, ":radius have to be greater than 0" if not params[:radius].nil? and not (params[:radius] > 0)
		raise StandardError, ":longitudes have to be a Fixnum" if not params[:longitudes].nil? and not (params[:longitudes].is_a? Fixnum)
		raise StandardError, ":longitudes have to be greater than 0" if not params[:longitudes].nil? and not (params[:longitudes] > 1)
		raise StandardError, ":latitudes have to be a Fixnum" if not params[:latitudes].nil? and not (params[:latitudes].is_a? Fixnum)
		raise StandardError, ":latitudes have to be greater than 2" if not params[:latitudes].nil? and not (params[:latitudes] > 2)
		raise StandardError, ":position is not a Vector3" if not params[:position].nil? and not (params[:position].kind_of? Vector3)
		
		radius      = params[:radius].nil?     ? 1  : params[:radius]	
		longitudes  = params[:longitudes].nil? ? 10 : (params[:longitudes])
		latitudes   = params[:latitudes].nil?  ? 10 : (params[:latitudes])
		vec = params[:position].nil? ? Vector3.new(0,0,0) : params[:position]

		vertices = Array.new
		indices  = Array.new

		#Start from bottom
		radius = -radius

		#First Point
		vertices << Vector3.new(0, 0, (radius))

		#### Construct Vertices ####
		1.upto(longitudes) do | long_i |
			alpha = ((180/(longitudes+1))*long_i) * Math::PI / 180 
			z = radius * Math.cos(alpha)
			1.upto(latitudes) do | lat_i |
				beta = ((360/latitudes )*lat_i) * Math::PI / 180
				x = radius * Math.sin(alpha) * Math.cos(beta)
				y = radius * Math.sin(alpha) * Math.sin(beta)
				vertices << (Vector3.new(x, y, z))
			end
		end
		#Last Point
		vertices << Vector3.new(0, 0, -radius)

		#### Construct Faces ####
		# Bottom and First Longitude Row
		1.upto(latitudes) do | lat_i |
			if lat_i == latitudes
				#Last Face
				indices << [0, 1, lat_i]
			else
				indices << [0, lat_i+1, lat_i]
			end
		end

		#Faces between
		2.upto(longitudes) do | long_i |
			1.upto(latitudes) do | lat_i |
				if lat_i == latitudes
					#Last One
					left_up    = latitudes * (long_i - 1) + lat_i
					right_up   = latitudes * (long_i - 1) + 1
					left_down  = latitudes * (long_i - 2) + lat_i
					right_down = latitudes * (long_i - 2) + 1
					indices << [left_down, right_down, left_up]
					indices << [right_down, right_up, left_up]
				else
					left_up    = latitudes * (long_i - 1) + lat_i
					right_up   = latitudes * (long_i - 1) + lat_i + 1
					left_down  = latitudes * (long_i - 2) + lat_i
					right_down = latitudes * (long_i - 2) + lat_i + 1
					indices << [left_down, right_down, left_up]
					indices << [right_down, right_up, left_up]
				end
			end
		end

		#Cover
		1.upto(latitudes) do | lat_i |
			if lat_i == latitudes
				#Last One
				left  = latitudes * (longitudes-1) + lat_i 
				right = latitudes * (longitudes-1) + 1
				up    = (latitudes * longitudes) + 1
				indices << [left, right, up]
			else
				left  = latitudes * (longitudes-1) + lat_i 
				right = latitudes * (longitudes-1) + lat_i + 1
				up    = (latitudes * longitudes) + 1
				indices << [left, right, up]
			end
		end

		# translate
 		mesh = TriMesh.new vertices, indices
 		mesh = translate mesh, :vector => vec

 		super(mesh.vertices, mesh.tri_indices)
	end

end