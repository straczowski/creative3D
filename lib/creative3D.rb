require "gmath3D"
include GMath3D

require "creative3D/version"
require "creative3D/transform"
require "creative3D/stl"

require "creative3D/primitives/cuboid"
require "creative3D/primitives/cylinder"
require "creative3D/primitives/sphere"
#require 'stl'

module Creative3D

	def self.version
		Creative3D::VERSION
	end

	def 

	def self.test_big
		stl = STL.new
		stl.set_workspace("C:/ruby3d/exampleSTL/")

		poly = Cylinder.new :height => 5, :segments => 60, :radius => 50
		stl.write :filename => "big_cylinder", :mesh => poly

		meshes = Array.new 
		100.times do |i|
			temp = Cuboid.new
			meshes << (translate temp, :x => (i*1.5))
		end
		stl.write :filename => "cubs", :mesh => meshes
		stl.write :filename => "cubs-ascii", :mesh => meshes, :format => :ascii
	end

	###### PRIMITIVES #######
	def self.test_sphere
		poly = Sphere.new :radius => 5, :longitudes => 2, :latitudes => 3
		poly = Sphere.new :radius => 5, :longitudes => 8, :latitudes => 4
		poly2 = Sphere.new :radius => 5 #PROBLEM bei binär!
		#Ich denke Problem da Anzahl der Dreiecke nicht richtig konvertiert wird
		poly2 = Sphere.new :radius => 5, :longitudes => 10, :latitudes => 10 #problem bei binär

		stl = STL.new
		stl.set_workspace("C:/ruby3d/exampleSTL/")
		stl.write :filename => "sphere", :mesh => poly
		stl.write :filename => "sphere2", :mesh => poly2
		stl.write :filename => "sphere2-ascii", :mesh => poly2, :format => :ascii 

		meshes = Array.new
		meshes << (translate poly, :x => -10)
		meshes << (poly2)
		stl.write :filename => "multi", :mesh => meshes
		stl.write :filename => "multi-ascii", :mesh => meshes, :format => :ascii
	end

	def self.test_cylinder
		meshes = Array.new

		poly = Cylinder.new :height => 10
		meshes << poly

		poly = Cylinder.new :height => 3, :segments => 3, :radius => 3, :position => Vector3.new(4, 0, 0)
		meshes << poly

		poly = Cylinder.new :position => Vector3.new(-4, 0, 0)
		meshes << poly

		stl = STL.new
		stl.set_workspace("C:/ruby3d/exampleSTL/")
		stl.write :filename => "cylinder", :mesh => meshes
	end

	def self.test_cuboid 
		poly = Cuboid.new :vector => Vector3.new(5, 2, 1)
		puts "Cuboid bei 0 vektor"
		poly.vertices.each { |v| puts v.to_s }
		poly = Cuboid.new 
		puts "Einheitswürfel"
		poly.vertices.each { |v| puts v.to_s }
		poly = Cuboid.new :postion => Vector3.new(5, 2, 1)
		puts "Einheitswürfel bei postion"
		poly.vertices.each { |v| puts v.to_s }
		poly = Cuboid.new :postion => Vector3.new(5, 2, 1), :width => 5
		puts "Position und Width"
		poly.vertices.each { |v| puts v.to_s }
		poly = Cuboid.new :width => 10, :height => 1, :depth => 4
		puts "Properties bei 0Vektor"
		poly.vertices.each { |v| puts v.to_s }

		stl = STL.new
		stl.set_workspace("C:/ruby3d/exampleSTL/")
		stl.write :filename => "cuboid", :mesh => poly

	end
	###### PRIMITIVES #######

	###### TRANSFORMATIONS ######
	def self.test_transformations
		test_stretch
		test_array
		test_mirror
		test_rotate
		test_scale
		test_translate
	end

	def self.test_stretch
		stl = STL.new
		stl.set_workspace("C:/ruby3d/exampleSTL/")
		poly = stl.read :filename => "cube"
		
		meshes = Array.new

		poly = (stretch poly, :axis => :z, :factor => 5, :vector => Vector3.new(0,0,0))
		meshes << poly 
		meshes << (rotate poly, :axis => :x, :degree => 90)

		stl.write :filename => "cross", :mesh => meshes
	end

	def self.test_array
		stl = STL.new
		stl.set_workspace("C:/ruby3d/exampleSTL/")
		poly = stl.read :filename => "cube"

		meshes = Array.new

		meshes << poly
		meshes << (translate poly, :vector => Vector3.new(-1.5, 0, 0))
		meshes << (translate poly, :vector => Vector3.new(0, 1.5, 0))

		stl.write :filename => "3cubes", :mesh => meshes
	end

	def self.test_mirror
		stl = STL.new
		stl.set_workspace("C:/ruby3d/exampleSTL/")
		poly = stl.read :filename => "cube"

		poly = mirror poly, :axis => :z, :vector => Vector3.new(0,0,0)
		puts "Axis Z"
		poly.vertices.each { |v| puts v.to_s }
		stl.write :filename => "mirror-quad", :mesh => poly

		poly = mirror poly, :axis => :y, :vector => Vector3.new(1,1,1)
		puts "Axis Z"
		poly.vertices.each { |v| puts v.to_s }		
		stl.write :filename => "mirror-quad2", :mesh => poly
	end

	def self.test_rotate
		stl = STL.new
		stl.set_workspace("C:/ruby3d/exampleSTL/")
		poly = stl.read :filename => "cube"

		poly1 = rotate poly, :axis => :z, :degree => 45
		puts "Axis Z from center"
		poly1.vertices.each { |v| puts v.to_s }

		b = Vector3.new(0, 0, 0)
		d = Vector3.new(0, 0, 5)
		line = Line.new b, d
		poly1 = rotate poly, :axis => line, :degree => 45
		puts "Axis Z"
		poly1.vertices.each { |v| puts v.to_s }
	end

	def self.test_scale
		stl = STL.new
		stl.set_workspace("C:/ruby3d/exampleSTL/")
		poly = stl.read :filename => "cube"

		poly = scale poly, :factor => 0.5
		puts "Half size"
		poly.vertices.each { |v| puts v.to_s }

		poly = stl.read :filename => "cube"
		poly = scale poly, :z => 5, :vector => (Vector3.new 0, 0, 0)
		stl.write :filename => "quad1", :mesh => poly 

		poly = stl.read :filename => "cube"
		poly = scale poly, :z => 5
		stl.write :filename => "quad2", :mesh => poly 
	end

	def self.test_translate
		stl = STL.new
		stl.set_workspace("C:/ruby3d/exampleSTL/")
		poly = stl.read :filename => "cube"

		puts "First"
		poly.vertices.each { |v| puts v.to_s }
		poly = translate poly, :vector => Vector3.new(1, 1, 1)
		puts "Second"
		poly.vertices.each { |v| puts v.to_s }
		puts "Einzeln"
		poly = translate poly, :x => -1
		poly = translate poly, :y => -1
		poly = translate poly, :z => -1
		poly.vertices.each { |v| puts v.to_s }
		#poly = translate poly, :vector => Vector3.new(1, 1, 1), :z => -1  #raise Error

	end
	###### TRANSFORMATIONS ######



	###### BASICS ######
	def self.test_triemesh
		a = Vector3.new 5, 2, 4
		b = Vector3.new 2, 6, 6
		c = Vector3.new 1, 8, 1

		vecs = [a, b, c]
		indicies = [[0, 1, 2]]

		tri = TriMesh.new(vecs, indicies)
	end

	def self.test_read_and_write
		stl = STL.new
		stl.set_workspace("C:/ruby3d/exampleSTL/")


		#stl.write ({:filename => "hellostl", :mesh => tri})
		poly = stl.read :filename => "cube" 
		stl.write :filename => "cube-copy", :mesh => poly 
		poly = stl.read :filename => "cube-copy" 
		stl.write :filename => "cube-copy-copy", :mesh => poly 
	end

end

# $ gem build creative3D.gemspec
# $ gem install creative3D-0.0.1.gem