
class Stick < TriMesh

	# line => Line, :thickness => Numeric, :segments => Fixum
	def initialize(line, params = {})
		raise StandardError, "first value have to be a FiniteLine" if not line.kind_of? FiniteLine
		raise StandardError, ":thickness have to be a Numeric" if not params[:thickness].nil? and not (params[:thickness].kind_of? Numeric)
		raise StandardError, ":segments have to be a Fixnum" if not params[:segments].nil? and not (params[:segments].is_a? Fixnum)
		raise StandardError, ":segments have to be greater than 2" if not params[:segments].nil? and not (params[:segments] > 2)

		r = params[:thickness].nil? ? 0.5 : (params[:thickness] / 2)
		s = params[:segments].nil?  ? 4 : params[:segments]
		h = line.length

		dir = line.end_point - line.start_point
		cyl_dir = Vector3.new(0, 0, h)

		x_rot = dir.angle(cyl_dir) * 180 / Math::PI
		z_rot = Vector3.new(dir.x, dir.y, 0).angle(Vector3.new(dir.x, 0, 0)) * 180 / Math::PI 

		puts "Degree X = " + x_rot.to_s
		puts "Degree z = " + z_rot.to_s

		stick = Cylinder.new :radius => r, :height => h, :segments => s
		stick = rotate stick, :axis => :y, :degree => x_rot, :vector => Vector3.new(0,0,0)
		stick = rotate stick, :axis => :z, :degree => -z_rot, :vector => Vector3.new(0,0,0)
		stick = translate stick, :vector => line.start_point

		super(stick.vertices, stick.tri_indices)
	end

end

