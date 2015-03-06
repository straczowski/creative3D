
class Cuboid < TriMesh

	attr_reader :start_point
	attr_reader :end_point

	# Define :vector => Vector3 or :width => Numeric, :height => Numeric, :depth => Numeric 
	# Optional :postion =>  Vector3
	def initialize(params = {})		
		
		raise StandardError, "Decide between :vector or :width/:height/:depth" if not params[:vector].nil? and not (params[:height].nil? or params[:width].nil? or params[:depth].nil?)
		raise StandardError, ":vector is not a Vector3" if not params[:vector].nil? and not (params[:vector].kind_of? Vector3)
		raise StandardError, ":position is not a Vector3" if not params[:position].nil? and not (params[:position].kind_of? Vector3)

		s = params[:postion].nil? ? Vector3.new(0,0,0) : params[:postion]

		if params[:vector].nil?
			cw = params[:width].nil?  ? 1  : params[:width]
			ch = params[:height].nil? ? cw : params[:height]
			cd = params[:depth].nil?  ? cw : params[:depth]  
			e = Vector3.new(cw+s.x, ch+s.y, cd+s.z)
		else 
			e = params[:vector]
		end

		@start_point = s;
		@end_point = e;

		width  = e.x - s.x 
		height = e.y - s.y
		depth  = e.z - s.z
		vertices = Array.new(8)
		vertices[0] = s
		vertices[1] = s + Vector3.new(width, 0, 0)
		vertices[2] = s + Vector3.new(width, 0, depth)
		vertices[3] = s + Vector3.new(0    , 0, depth)
		vertices[4] = s + Vector3.new(0    , height, 0)
		vertices[5] = s + Vector3.new(width, height, 0)
		vertices[6] = s + Vector3.new(width, height, depth)
		vertices[7] = s + Vector3.new(0    , height, depth)

		indices = [
	        [0, 1, 2],
	        [0, 2, 3],
	        [1, 5, 6],
	        [1, 6, 2],
	        [5, 4, 7],
	        [5, 7, 6],
	        [4, 0, 3],
	        [4, 3, 7],
	        [2, 6, 7],
	        [2, 7, 3],
	        [0, 4, 5],
	        [0, 5, 1]
	    ]
		super(vertices, indices)
	end

end