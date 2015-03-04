require "creative3D/version"
require "creative3D/transform"
require "creative3D/stl"

require "gmath3D"
include GMath3D

#require 'stl'

module Creative3D

	def self.version
		Creative3D::VERSION
	end

	def self.test 
		stl = STL.new
		stl.set_workspace("C:/ruby3d/exampleSTL/")
		poly = stl.read :filename => "cube"

		poly = scale :mesh => poly, :factor => 0.5
		puts "Half size"
		poly.vertices.each { |v| puts v.to_s }

		poly = stl.read :filename => "cube"
		poly = scale :mesh => poly, :z => 5, :vector => (Vector3.new 0, 0, 0)
		stl.write :filename => "quad1", :mesh => poly 

		poly = stl.read :filename => "cube"
		poly = scale :mesh => poly, :z => 5
		stl.write :filename => "quad2", :mesh => poly 
	end

	def self.test_translate
		stl = STL.new
		stl.set_workspace("C:/ruby3d/exampleSTL/")
		poly = stl.read :filename => "cube"

		puts "First"
		poly.vertices.each { |v| puts v.to_s }
		poly = translate :mesh => poly, :vector => Vector3.new(1, 1, 1)
		puts "Second"
		poly.vertices.each { |v| puts v.to_s }
		puts "Einzeln"
		poly = translate :mesh => poly, :x => -1
		poly = translate :mesh => poly, :y => -1
		poly = translate :mesh => poly, :z => -1
		poly.vertices.each { |v| puts v.to_s }
		#poly = translate :mesh => poly, :vector => Vector3.new(1, 1, 1), :z => -1  #raise Error

	end

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